defmodule Takso.ParkingBooking do
  @derive {Poison.Encoder, only: [:id, :estimated_cost, :estimated_time, :paying_status, :user_id]}
    use Takso.Web, :model
  
    schema "parkingBookings" do
      field :estimated_cost, :float
      field :estimated_time, :integer
      field :paying_status, :string
      field :user_id, :integer


      timestamps()
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:estimated_cost, :estimated_time, :paying_status])
    end
  end
  