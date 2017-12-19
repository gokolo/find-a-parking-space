defmodule Takso.User do

  @derive {Poison.Encoder, only: [:id, :username, :card_holder_name, :card_number, :card_cvc, :expiry_date]}
  use Takso.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :card_holder_name, :string
    field :card_number, :string
    field :card_cvc, :string
    field :expiry_date, :string
    field :encrypted_password, :string
    field :role, :string, default: "customer"
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password, :card_holder_name, :card_number, :card_cvc, :expiry_date, :role ])
    |> validate_required([:name, :username, :password, :role])
    |> encrypt_password
  end

  def encrypt_password(changeset) do
    if changeset.valid? do
      IO.inspect(changeset)
      put_change(changeset, :encrypted_password, Comeonin.Pbkdf2.hashpwsalt(changeset.changes[:password]))
    else
      changeset
    end
  end
end
