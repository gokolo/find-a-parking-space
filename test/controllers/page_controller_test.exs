defmodule Takso.PageControllerTest do
  use Takso.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ ~r/Find Me A Parking Place/ 
  end
end
