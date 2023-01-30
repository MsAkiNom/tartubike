defmodule TartuBikeWeb.SearchControllerTest do
  use TartuBikeWeb.ConnCase
  use Ecto.Schema

  alias TartuBike.{BikeSharing.Dock, Repo}

  import Ecto.Query, only: [from: 2]


 test "Searching Acceptance by available docker stations", %{conn: conn}do

  Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu"})
  Repo.insert!(%Dock{status: "available", location: "Narva maantee 18, 51009, Tartu"})

  query = from d in Dock, where: d.status == "available", select: d
  [d1, _] = Repo.all(query)

  assert d1.location == "Muuseumi tee 2, 51009, Tartu"

  conn = post(conn, Routes.search_path(conn, :nearby), %{location: "Raatuse 22"})


  response = assert html_response(conn, 200)

 end

end
