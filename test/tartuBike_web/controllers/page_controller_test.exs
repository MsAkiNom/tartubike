defmodule TartuBikeWeb.PageControllerTest do
  use TartuBikeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Tartu Bike Sharing"
  end
end
