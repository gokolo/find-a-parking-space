defmodule Takso.BookingAPIController do
  use Takso.Web, :controller
  
  
  def create(conn, %{"pickup_address" => pickup_address, "dropoff_address" => dropoff_address} = params) do
    user = Guardian.Plug.current_resource(conn)
    Takso.TaxiAllocator.start_link(user, pickup_address, dropoff_address)
    conn
    |> put_status(201)
    |> json(%{msg: "We are processing your request"})
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