defmodule Takso.BookingNotification do
    import Ecto.Query, only: [from: 2]
    alias Ecto.{Changeset,Multi}
    alias Takso.{Repo,ParkingBooking,ParkingPlace,User}
    use GenServer
    
    def start_link(username, estimated_time, booking_id, place_id, kill_process) do
          
          GenServer.start_link(Takso.BookingNotification, %{}
                                                |> Map.put(:username, username)
                                                |> Map.put(:estimated_time, estimated_time)
                                                |> Map.put(:booking_id, booking_id)
                                                |> Map.put(:kill_process, kill_process)
                                                |> Map.put(:place_id, place_id), name: String.to_atom("#{booking_id}"))
        
    end
        
    def init(request) do
        Process.send_after(self(), :notify_customer, request.estimated_time*60*1000 - 5*60*1000)
        {:ok, request}
    end

    def handle_booking(booking_reference, status) do
        if status == "accepted" do
            IO.puts("status    "<> status)
            GenServer.cast(booking_reference, :increase_one_hour)
        else
            GenServer.cast(booking_reference, :reject)
        end
    end

    def handle_cast(:reject, request) do
        Process.send_after(self(), :notify_customer, 10000)
        {:noreply, %{}
            |> Map.put(:username, request.username)
            |> Map.put(:estimated_time, request.estimated_time)
            |> Map.put(:booking_id, request.booking_id)
            |> Map.put(:kill_process, 1)
            |> Map.put(:place_id, request.place_id)}

    end

    def handle_cast(:increase_one_hour, request) do
        IO.puts("extend booking time by one hour")
        query = from t in ParkingPlace, where: t.id == ^request.place_id, select: t
        place = Repo.one(query)

        query = from t in ParkingBooking, where: t.id == ^request.booking_id, select: t
        booking = Repo.one(query)

        query = from t in User, where: t.username == ^request.username, select: t
        current_user = Repo.one(query)

        if (booking.pay_type == 'HOURLY') do
            changeset = ParkingBooking.changeset(%ParkingBooking{}, %{user_id: current_user.id})
            |> Changeset.put_change(:paying_status, "UNPAID")
            |> Changeset.put_change(:estimated_time, 60)
            |> Changeset.put_change(:estimated_cost, place.pricePerHour)
            |> Changeset.put_change(:place_id, request.place_id)
            |> Changeset.put_change(:pay_type, "HOURLY")
            Repo.insert!(changeset)
        else
            changeset = ParkingBooking.changeset(%ParkingBooking{}, %{user_id: current_user.id})
            |> Changeset.put_change(:paying_status, "UNPAID")
            |> Changeset.put_change(:estimated_time, 60)
            |> Changeset.put_change(:estimated_cost, place.pricePerMin*12)
            |> Changeset.put_change(:place_id, request.place_id)
            |> Changeset.put_change(:pay_type, "REAL_TIME")
            Repo.insert!(changeset)
        end
        Process.send_after(self(), :notify_customer, 55*60*1000)
        {:noreply, %{}
            |> Map.put(:username, request.username)
            |> Map.put(:estimated_time, request.estimated_time)
            |> Map.put(:booking_id, request.booking_id)
            |> Map.put(:kill_process, 0)
            |> Map.put(:place_id, request.place_id)}
    end

    def handle_info(:notify_customer, request) do
        if (request.kill_process ==1 ) do
            IO.puts("killing process")
            query = from t in ParkingPlace, where: t.id == ^request.place_id, select: t
            place = Repo.one(query)
            ParkingPlace.changeset(place)
              |> Changeset.put_change(:currentCars, place.currentCars - 1)
              |> Repo.update
            Process.exit(self(), :normal)
            {:noreply,  %{}
                |> Map.put(:username, request.username)
                |> Map.put(:estimated_time, request.estimated_time)
                |> Map.put(:booking_id, request.booking_id)
                |> Map.put(:kill_process, 1)
                |> Map.put(:place_id, request.place_id)}
        else
            IO.puts("sending notification")
            Takso.Endpoint.broadcast("customer:"<>request.username, "requests", %{}  
                |> Map.put(:booking_id, request.booking_id))
            {:noreply,  %{}
                |> Map.put(:username, request.username)
                |> Map.put(:estimated_time, request.estimated_time)
                |> Map.put(:booking_id, request.booking_id)
                |> Map.put(:kill_process, 1)
                |> Map.put(:place_id, request.place_id)}
        end
    end

    def handle_info(:kill, request) do
        IO.puts("killing process")
        query = from t in ParkingPlace, where: t.id == ^request.place_id, select: t
        place = Repo.one(query)
        ParkingPlace.changeset(place)
          |> Changeset.put_change(:currentCars, place.currentCars - 1)
          |> Repo.update
        Process.exit(self(), :normal)
        {:noreply, request}
    end
    
end