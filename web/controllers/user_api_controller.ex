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
            |> json(%{message: "Successfully Signed Up"})
          {:error, changeset} ->
            conn
            |> put_status(409)
            |> json(%{message: "Failed to Create User"})
        end
    end

    def update(conn, params) do
        user = Guardian.Plug.current_resource(conn)
        user = Repo.get!(User, user.id)
        changeset = User.changeset(user, params)
        updated_user = Repo.update!(changeset)
        conn
        |> put_status(200)
        |> json(updated_user)
      end

      def get(conn, %{}) do
        user = Guardian.Plug.current_resource(conn)
        user = Repo.get!(User, user.id)
        conn
        |> put_status(200)
        |> json(user)    
      end
end