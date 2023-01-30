defmodule TartuBikeWeb.RouteController do
  use TartuBikeWeb, :controller
  alias TartuBike.BikeSharing.Route
  alias TartuBike.Repo

  def index(conn, _params) do
    routes = Repo.all(Route)|>Repo.preload(:start_dock)|>Repo.preload(:end_dock)
    render(conn, "index.html", routes: routes)
  end
end
