defmodule TartuBikeWeb.SearchController do
  use TartuBikeWeb, :controller
  alias TartuBike.{Repo, BikeSharing.Dock, BikeSharing.Bike}
  alias TartuBike.Geolocation
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    docks = getStationsDetail()
    render(conn, "index.html", docks: docks, location: %{}, nearest_distance: nil)
  end

  def nearby(conn, %{"location" => location}) do
    docks = getStationsDetail()
    case Geolocation.find_location(location) do
      [lat, lon] -> stations = Enum.map(docks, fn d -> d.station end)
                    case docks do
                      [] ->
                        conn
                        |> put_flash(:info, "No docks are available")
                        |> render("index.html", docks: [], location: %{lat: lat, lon: lon}, nearest_distance: nil)
                      _ ->
                        ds = Geolocation.distances(stations, lat, lon)
                        docks_with_distances = Enum.zip_with(docks, ds, fn dock, d -> %{dock | station: %{dock.station | distance: d}} end)
                        sorted_docks = Enum.sort_by(docks_with_distances, &(&1.station.distance))
                        render(conn, "index.html",  docks: sorted_docks, location: %{lat: lat, lon: lon}, nearest_distance: nil)
                    end

      _ -> render(conn, "index.html",  docks: docks, location: %{}, nearest_distance: nil)
    end
  end

  def nearme(conn, %{"currLat" => lat, "currLon" => lon}) do
    docks = getStationsDetail()
    stations = Enum.map(docks, fn d -> d.station end)
    ds = Geolocation.distances(stations, lat, lon)
    docks_with_distances = Enum.zip_with(docks, ds, fn dock, d -> %{dock | station: %{dock.station | distance: d}} end)
    sorted_docks = Enum.sort_by(docks_with_distances, &(&1.station.distance))

    s = sorted_docks |> hd
    render(conn, "index.html",  docks: sorted_docks, location: %{lat: lat, lon: lon}, nearest_distance: "#{s.station.name} (#{s.station.distance} km)")
  end

  def showBikes(conn, %{"station_id" => station_id}) do
    bikes = getBikes(station_id)
    render(conn, "bikes.html",  bikes: bikes)
  end

  defp getStationsDetail() do
    query = from bike in Bike,
    join: dock in Dock, on: dock.id == bike.dock_id,
    order_by: dock.id,
    group_by: dock.id,
    group_by: dock.name,
    group_by: dock.capacity,
    group_by: dock.latitude,
    group_by: dock.longitude,
    select: %{ station: dock,
              classic: fragment("SUM(CASE WHEN type = ? THEN 1 ELSE 0 END)", "classic"),
              electric: fragment("SUM(CASE WHEN type = ? THEN 1 ELSE 0 END)", "electric")
            }
    Repo.all(query)
  end

  defp getBikes(station_id) do
    query = from bike in Bike,
    where: bike.dock_id == ^station_id,
    select: bike

    Repo.all(query)
  end
end
