defmodule TartuBike.Geolocation do
  alias TartuBike.{Repo, BikeSharing.Dock}

  def find_location(address) do
    uri = "http://dev.virtualearth.net/REST/v1/Locations?q=1#{URI.encode(address)}%&key=#{get_key()}"
    response = HTTPoison.get! uri
    matches = Regex.named_captures(~r/coordinates\D+(?<lat>-?\d+.\d+)\D+(?<long>-?\d+.\d+)/, response.body)
    case {matches["lat"], matches["long"]} do
      {nil,nil} -> []
      {v1, v2} -> case [v1|>Float.parse, v2|>Float.parse] do
                  [{lat, _}, {lon, _}] -> [lat, lon]
                  _ -> []
                end
    end
  end


  def distances(docks, d1, d2) do
    data = %{origins: Enum.map(docks, fn d -> %{latitude: d.latitude, longitude: d.longitude} end), destinations: [%{latitude: d1, longitude: d2}], travelMode: "driving"}
    requestTravelDistance(data)
  end

  def distanceOfRide(start_dock_id, end_dock_id) do
    if start_dock_id == nil or end_dock_id == nil do
      [0]
    else
      start_dock = Repo.get!(Dock, start_dock_id)
      end_dock = Repo.get!(Dock, end_dock_id)
      data = %{origins: [%{latitude: start_dock.latitude, longitude: start_dock.longitude}],
      destinations: [%{latitude: end_dock.latitude, longitude: end_dock.longitude}],
      travelMode: "driving"}
      requestTravelDistance(data)
    end
  end

  defp get_key(), do: "AhVpGt7Vsn2HJtlh8kmcD6BSyONDLO_UwXCRIBr2jk21_KIh8axCb9esf8GtncvG"

  defp requestTravelDistance(data) do
    uri = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?key=#{get_key()}"
    json_data = Jason.encode!(data)
    response = HTTPoison.post!(uri, json_data)
    res = Jason.decode!(response.body)
    Enum.map(hd(hd(res["resourceSets"])["resources"])["results"], fn m -> m["travelDistance"] end)
  end

end
