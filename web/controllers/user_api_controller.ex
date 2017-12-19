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

    def update(conn, %{"card_cvc" => card_cvc, "card_holder_name" => card_holder_name, 
    "card_number" => card_number, "expiry_date" => expiry_date, "id" => id, "password" => password, "username" => username} = params) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user, params)
        Repo.update!(changeset)
        conn
        |> put_status(200)
        |> json(%{message: "Successfully Updated"})
      end

      def get(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        conn
        |> put_status(200)
        |> json(user)    
      end
end