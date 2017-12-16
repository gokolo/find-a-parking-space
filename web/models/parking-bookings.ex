defmodule Takso.ParkingBooking do
  @derive {Poison.Encoder, only: [:id, :estimated_cost, :estimated_time, :paying_status, :user_id, :inserted_at, :place_id, :pay_type]}
    use Takso.Web, :model
  
    schema "parkingBookings" do
      field :estimated_cost, :float
      field :estimated_time, :integer
      field :paying_status, :string
      field :user_id, :integer
      field :place_id, :integer
      field :pay_type, :string


      timestamps()
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:estimated_cost, :estimated_time, :paying_status, :user_id, :place_id, :pay_type])
    end
  end
  