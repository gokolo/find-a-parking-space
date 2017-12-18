defmodule Takso.Repo.Migrations.AddCardIntoInUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :card_holder_name, :string
      add :card_number, :string
      add :card_cvc, :string
      add :expiry_date, :string
    end
  end
end
