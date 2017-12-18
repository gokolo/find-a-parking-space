defmodule Takso.UserAPIController do
    use Takso.Web, :controller
    import Ecto.Query, only: [from: 2]
    alias Ecto.{Changeset,Multi}
    alias Takso.User

    def create(conn, user_params) do
        changeset = User.changeset(%User{}, user_params)
        case Repo.insert(changeset) do
          {:ok, changeset} ->
            conn
            |> put_status(201)
            |> json(%{message: "Successfully Singed Up"})
          {:error, changeset} ->
            conn
            |> put_status(409)
            |> json(%{message: "Failed to Create User"})
        end
    end
end