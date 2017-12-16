defmodule Takso.BookingAPIController do
  import Ecto.Query, only: [from: 2]
  alias Ecto.{Changeset,Multi}
  import Canary.Plugs
  alias Takso.{Taxi,Repo,Geolocator,Booking,ParkingPlace,ParkingBooking}
  use Takso.Web, :controller
  
  
  def create(conn, %{"destination_address" => destination_address, "intented_stay_time" => intented_stay_time} = params) do
    user = Guardian.Plug.current_resource(conn)
    query = from t in ParkingPlace, where: t.type == "PLACE", select: t
    all_places = Repo.all(query)
    query = from t in ParkingPlace, where: t.type == "ROAD", select: t
    all_roads = Repo.all(query)
    map_center = %{lat: 58.382810, lng: 26.734172}
    conn
    |> put_status(201)
    |> json(%{places: all_places, roads: all_roads, center: map_center, intented_stay_time: intented_stay_time})
  end

  def update(conn, %{"id" => booking_id, "status" => status} = params) do
    # The following line will broadcast a message through the channel "customer:lobby" announcing that the taxi will arrive in 5 mins
    # Henceforth, the following line must be updated for using private channels
    #Takso.Endpoint.broadcast("customer:lobby", "requests", %{msg: "Your taxi will arrive in 5 mins"})

    # Note that, additionally, the line above should be relocated to the GenServer
    # Consider using the following line (note that accept_booking is already defined in TaxiAllocator)
    
    Takso.TaxiAllocator.handle_booking(String.to_atom("#{booking_id}"), status)
    

    conn
    |> put_status(200)
    |> json(%{msg: "Notification sent to the customer"})
  end

  def create2(conn, %{"paying_status" => paying_status, "estimated_time" => estimated_time, 
                      "estimated_cost" => estimated_cost, "place_id" => place_id} = params) do
    user = Guardian.Plug.current_resource(conn)
    query = from t in ParkingPlace, where: t.id == ^place_id, select: t
    place = Repo.one(query)
    if(place.maximumSize > place.currentCars) do
      change_set = ParkingPlace.changeset(place)
                  |> Changeset.put_change(:currentCars, place.currentCars + 1)
    else
      conn
      |> put_status(409)
      |> json(%{message: "this place is already alocated. please try another one"})
    end
    user_id = conn.assigns.current_user.id
    IO.inspect(user_id)
    changeset = ParkingBooking.changeset(%ParkingBooking{}, %{user_id: user_id})
                |> Changeset.put_change(:paying_status, paying_status)
                |> Changeset.put_change(:estimated_time, estimated_time)
                |> Changeset.put_change(:estimated_cost, estimated_cost)
    booking = Repo.insert!(changeset)
    IO.inspect(booking)
    conn
    |> put_status(201)
    |> json(%{message: "booking request served successfully"})
  end

  def summary(conn, %{}=params) do
    user_id = conn.assigns.current_user.id
    query  = from t in ParkingBooking, where: t.user_id == ^user_id, select: t
    all_bookings = Repo.all(query)
    IO.inspect(all_bookings)
    conn
    |> put_status(200)
    |> json(all_bookings)
  end

  def pay(conn, %{"id" => booking_id} = params) do
    query = from t in ParkinBooking, where: t.id == ^booking_id, select: t
    booking = Repo.one(query)
    ParkinBooking.changeset(booking) |> Changeset.put_change(:paying_status, "PAID")
    |> Repo.update

    conn
    |> put_status(200)
    |> json(%{message: "payment successfull"})
  end

end