defmodule Takso.BookingTest do
  use Takso.ModelCase

  alias Takso.Booking

  test "Dropoff address must be there" do
    changeset = Booking.changeset(%Booking{}, %{start_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :dropoff_address
  end

  test "Pickup address must be there" do
    changeset = Booking.changeset(%Booking{}, %{parking_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :pickup_address
  end

end
