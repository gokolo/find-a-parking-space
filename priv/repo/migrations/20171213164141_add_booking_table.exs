defmodule Takso.Repo.Migrations.AddBookingTable do
  use Ecto.Migration

  def change do
    create table(:parkingBookings) do
      
      add :estimated_cost, :float
      add :estimated_time, :integer
      add :paying_status, :string

      timestamps()
    end
  end
end
