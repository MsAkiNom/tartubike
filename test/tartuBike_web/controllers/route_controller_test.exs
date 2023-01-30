defmodule TartuBikeWeb.RouteControllerTest do
  use TartuBikeWeb.ConnCase
  use Ecto.Schema

  alias TartuBike.{ Repo}


 test "See popular routes", %{conn: conn} do

  conn = get(conn, Routes.route_path(conn, :index))

  assert html_response(conn, 200)  =~ "Popular attractions"

 end

end
