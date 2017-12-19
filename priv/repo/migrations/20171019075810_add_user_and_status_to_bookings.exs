defmodule Takso.Repo.Migrations.AddUserAndStatusToBookings do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :status, :string
    end
  end
end
