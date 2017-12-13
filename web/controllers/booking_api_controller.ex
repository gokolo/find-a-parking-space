defmodule Takso.BookingAPIController do
  import Ecto.Query, only: [from: 2]
  alias Takso.{Taxi,Repo,Geolocator,Booking,ParkingPlace}
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
end