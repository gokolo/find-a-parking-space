defmodule Takso.Repo.Migrations.AddBookingTable do
  use Ecto.Migration

  def change do
    create table(:parkingBookings) do
      
      add :estimated_cost, :float
      add :estimated_time, :integer
      add :paying_status, :string
      add :user_id, :integer
      add :place_id, :integer
      add :pay_type, :string
      
      timestamps()
    end
  end
end
