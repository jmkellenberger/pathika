defmodule PathikaWeb.PageControllerTest do
  use PathikaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Pathika!"
  end
end
