defmodule Takso.LoginControllerTest do
use Takso.ConnCase
alias Takso.{Taxi, Repo}

  test "POST /bookings (must be logged in)", %{conn: conn} do
    [%{location: "Kaubamaja", username: "fred1"},
    %{location: "Kaubamaja", username: "bilbo"}]
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2"]}
    conn1 = get conn, redirected_to(conn)
    assert html_response(conn1, 200) =~ ~r/You are not logged in/
  end

end