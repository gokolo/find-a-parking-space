defmodule Takso.ParkingPlace do
    @derive {Poison.Encoder, only: [:id, :startLat, :startLng, :endLat, :endLng, :type, :region, :pricePerHour, :pricePerMin, :maximumSize, :currentCars]}
    use Takso.Web, :model
  
    schema "parkingPlace" do
      field :startLat, :float
      field :startLng, :float
      field :endLat, :float
      field :endLng, :float
      field :type, :string
      field :region, :string
      field :pricePerHour, :float
      field :pricePerMin, :float
      field :maximumSize, :integer
      field :currentCars, :integer, default: 0
  
      timestamps()
    end
  
    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:startLat, :startLng, :endLat, :endLng, :type, :region, :pricePerHour, :pricePerMin, :maximumSize, :currentCars])
    end
  end
  