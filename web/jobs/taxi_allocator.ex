defmodule Takso.TaxiAllocator do
    import Ecto.Query, only: [from: 2]
    alias Takso.{Taxi,Repo,Geolocator,Booking}
    use GenServer
    @decision_timeout Application.get_env(:takso, :decision_timeout)
    
    def start_link(user, pickup_address, dropoff_address) do

        changeset = Booking.changeset(%Booking{}, %{"pickup_address" => pickup_address, "dropoff_address" => dropoff_address})
        booking = Repo.insert!(changeset)
    
        query = from t in Taxi, where: t.status == "available", select: t
        available_taxis = Repo.all(query)
        if length(available_taxis) > 0 do
          originUrls  = generate_url(available_taxis, "");
          closest_taxi_index = Geolocator.get_closest_taxi_index(originUrls, pickup_address <> " Tartu Estonia")
          taxi = Enum.at(available_taxis, closest_taxi_index)
          Takso.Endpoint.broadcast("driver:"<>taxi.username, "requests", %{"pickup_address" => pickup_address, "dropoff_address" => dropoff_address} |> Map.put(:booking_id, booking.id))
          GenServer.start_link(Takso.TaxiAllocator, %{}
                                                |> Map.put(:pickup_address, pickup_address)
                                                |> Map.put(:dropoff_address, dropoff_address)
                                                |> Map.put(:customer_username, user.username)
                                                |> Map.put(:taxi_username, [taxi.username])
                                                |> Map.put(:booking_id, booking.id)
                                                |> Map.put(:taxi_location, taxi.location), name: String.to_atom("#{booking.id}"))
        else
          Takso.Endpoint.broadcast("customer:"<>user.username, "requests", %{msg: "no taxi available"})
        end
    end
        
    def init(request) do
        Process.send_after(self(), :notify_customer, @decision_timeout)
        {:ok, request}
    end

    def handle_booking(booking_reference, status) do
        if status == "accepted" do
            IO.puts("status    "<> status)
            GenServer.cast(booking_reference, :accept_booking)
        else
            GenServer.cast(booking_reference, :reject_booking)
        end
    end

    def handle_cast(:reject_booking, request) do
        query = from t in Taxi, where: t.status == "available" and t.username not in ^request.taxi_username, select: t
        available_taxis = Repo.all(query)
        IO.puts("#{length(available_taxis)}")
        if length(available_taxis) > 0 do
            originUrls  = generate_url(available_taxis, "");
            closest_taxi_index = Geolocator.get_closest_taxi_index(originUrls, request.pickup_address <> " Tartu Estonia")
            taxi = Enum.at(available_taxis, closest_taxi_index)
            Takso.Endpoint.broadcast("driver:"<>taxi.username, "requests", %{} 
                                                                            |> Map.put(:pickup_address, request.pickup_address)
                                                                            |> Map.put(:dropoff_address, request.dropoff_address) 
                                                                            |> Map.put(:booking_id, request.booking_id))
            {:noreply, %{} 
                        |> Map.put(:pickup_address, request.pickup_address) 
                        |> Map.put(:dropoff_address, request.dropoff_address)
                        |> Map.put(:customer_username, request.customer_username)
                        |> Map.put(:taxi_username, [taxi.username| request.taxi_username])
                        |> Map.put(:booking_id, request.booking_id)
                        |> Map.put(:taxi_location, taxi.location)}
        else
            Takso.Endpoint.broadcast("customer:"<>request.customer_username, "requests", %{msg: "no taxi available"})
            Process.exit(self(), :normal)
            {:noreply, request}
        end
    end

    def handle_cast(:accept_booking, request) do
        IO.puts("userName: "<>request.customer_username)
        time_to_pickup = Geolocator.trip_duration(request.taxi_location <>  " Tartu Estonia", request.pickup_address <> " Tartu Estonia")
        trip_duration = Geolocator.trip_duration(request.pickup_address <> " Tartu Estonia", request.dropoff_address <> " Tartu Estonia")
        Takso.Endpoint.broadcast("customer:"<>request.customer_username, "requests", %{msg: "taxi arriving soon \ntime to pickup: " <> time_to_pickup <> " trip duration: "<> trip_duration})
        Process.exit(self(), :normal)
        {:noreply, request}
    end

    def handle_info(:notify_customer, request) do
        query = from t in Taxi, where: t.status == "available" and t.username not in ^request.taxi_username, select: t
        available_taxis = Repo.all(query)
        if length(available_taxis) > 0 do
            originUrls  = generate_url(available_taxis, "");
            closest_taxi_index = Geolocator.get_closest_taxi_index(originUrls, request.pickup_address <> " Tartu Estonia")
            taxi = Enum.at(available_taxis, closest_taxi_index)
            Takso.Endpoint.broadcast("driver:"<>taxi.username, "requests", %{} 
                                                                            |> Map.put(:pickup_address, request.pickup_address)
                                                                            |> Map.put(:dropoff_address, request.dropoff_address) 
                                                                            |> Map.put(:booking_id, request.booking_id))
            Process.send_after(self(), :notify_customer, @decision_timeout)
            {:noreply, %{} 
                        |> Map.put(:pickup_address, request.pickup_address) 
                        |> Map.put(:dropoff_address, request.dropoff_address)
                        |> Map.put(:customer_username, request.customer_username)
                        |> Map.put(:taxi_username, [taxi.username| request.taxi_username])
                        |> Map.put(:booking_id, request.booking_id)
                        |> Map.put(:taxi_location, taxi.location)}
        else
            Takso.Endpoint.broadcast("customer:"<>request.customer_username, "requests", %{msg: "no taxi available"})
            Process.exit(self(), :normal)
            {:noreply, request}
        end
    end

    def generate_url([], acc) do
        acc
    end
    def generate_url([head|tail], acc) do
        if acc == "" do
            generate_url(tail, head.location <> " Tartu Estonia")
        else
            generate_url(tail, acc <> "|" <> head.location <> " Tartu Estonia")
        end
    end
end