defmodule Takso.Repo.Migrations.AddParkingPlace do
  use Ecto.Migration

  def change do
    create table(:parkingPlace) do
      add :startLat, :float
      add :startLng, :float
      add :endLat, :float
      add :endLng, :float
      add :type, :string
      add :region, :string
      add :pricePerHour, :float
      add :pricePerMin, :float

      timestamps()
    end
  end
end
