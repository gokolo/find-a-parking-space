defmodule Takso.ParkingBooking do
  @derive {Poison.Encoder, only: [:estimated_cost, :estimated_time, :paying_status]}
    use Takso.Web, :model
  
    schema "parkingBookings" do
      field :estimated_cost, :float
      field :estimated_time, :integer
      field :paying_status, :string
      belongs_to :user, Takso.User
      belongs_to :parking_place, Takso.ParkingPlace
      timestamps()
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:estimated_cost, :estimated_time, :paying_status])
    end
  end
  