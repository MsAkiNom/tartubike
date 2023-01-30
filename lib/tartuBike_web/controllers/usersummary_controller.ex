defmodule TartuBikeWeb.UsersummaryController do
  use TartuBikeWeb, :controller
  alias TartuBike.BikeSharing.{Ride, Dock, Bike}
  alias TartuBike.{Repo, Accounts.User, Invoices.Invoice}
  import Ecto.Query, only: [from: 2]


  def usersummary(conn, _param) do
    render(conn, "index.html")
  end

  def userusage(conn, _param) do
    user = TartuBike.Authentication.load_current_user(conn)
    query = from r in Ride,
            join: bike in Bike,
            join: dock in Dock,
            on:
            r.bike_id == bike.id and
            r.start_dock_id == dock.id,
            where: r.user_id == ^user.id ,
            select: r

    user_usage = Repo.all(query) |> Repo.preload([:start_dock, :end_dock])
    total_kilo = getTotalKiloRidden(conn)

    render(conn, "userusage.html", user_usage: user_usage, total_kilo: total_kilo )
  end

  def ridehistory(conn, _param) do

    user = TartuBike.Authentication.load_current_user(conn)
    query = from r in Ride,
            join: bike in Bike,
            join: dock in Dock,
            on:
            r.bike_id == bike.id and
            r.start_dock_id == dock.id,
            where: r.user_id == ^user.id ,
            select: r

    ride_history = Repo.all(query) |> Repo.preload([:start_dock, :end_dock])

    render(conn, "ridehistory.html", ride_history: ride_history)

  end


  defp getTotalKiloRidden(conn) do
    user = TartuBike.Authentication.load_current_user(conn)
    query =
    from r in Ride,
      where: r.user_id == ^user.id,
      select: sum(r.distance)
    Repo.one(query)
  end

  def invoicehistory(conn, _param) do
    user = TartuBike.Authentication.load_current_user(conn)
    query = from inv in Invoice ,
    join: user in User,
    on:
    inv.user_id == user.id,
    where: inv.user_id == ^user.id,
    order_by: inv.invoice_date,
    select: inv

    invoice_history = Repo.all(query) |> Repo.preload([:user])
    render(conn, "invoicehistory.html", invoice: invoice_history)
  end

end
