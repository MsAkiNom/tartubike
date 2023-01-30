defmodule TartuBikeWeb.BikeController do
  use TartuBikeWeb, :controller
  alias TartuBike.{Repo, Fee, Accounts.User, Geolocation, Invoices.Invoice}
  alias TartuBike.BikeSharing.{Bike, Ride, Dock, Booking}
  import Ecto.Query, only: [from: 2]

  def book(conn, _params) do
    render(conn, "book.html")
  end

  def bookit(conn, %{"id" => id}) do
    user = TartuBike.Authentication.load_current_user(conn)
    bike = Repo.get(Bike, id) |> Repo.preload(:dock)
    res = validate_bike_exists(bike, user)
    |> validate_bike_available()
    |> validate_time()
    |> book_bike()
    case res do
      {:error, %{reason: :wrong_bike_id}} -> conn
                                              |> put_flash(:error, "Failed to book the bike. Bike id was wrong.")
                                              |> redirect(to: Routes.bike_path(conn, :rent))
      {:error, %{reason: :unavailable_bike}} -> conn
                                                  |> put_flash(:error, "Failed to book the bike. Bike isn't available")
                                                  |> redirect(to: Routes.bike_path(conn, :rent))
      {:ok, _} ->  conn
                    |> put_flash(:info, "You have successfully booked the bike.")
                    |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def rent(conn, _params) do
    user = TartuBike.Authentication.load_current_user(conn)

    query =
      from r in Ride,
        where: r.user_id == ^user.id and is_nil(r.ended_at),
        select: r

    unfinishedRide = Repo.all(query)
    render(conn, "rent.html", ride: unfinishedRide)
  end


  def rentit(conn, %{"id" => id}) do
    user = TartuBike.Authentication.load_current_user(conn)
    bike = Repo.get(Bike, id) |> Repo.preload(:dock)

    res = validate_bike_exists(bike, user)
    |>validate_bike_available_or_booked()
    |>validate_time()
    |>start_ride()

    case res do
      {:error, %{reason: :wrong_bike_id}} -> conn
                                              |> put_flash(:error, "Failed to rent the bike. Bike id was wrong.")
                                              |> redirect(to: Routes.bike_path(conn, :rent))
      {:error, %{reason: :unavailable_bike}} -> conn
                                                  |> put_flash(:error, "Failed to rent the bike. Bike isn't available")
                                                  |> redirect(to: Routes.bike_path(conn, :rent))
      {:error, %{reason: :non_working_time}} -> conn
                                                  |> put_flash(:error, "You can't rent a bike between 1 am and 5 am")
                                                  |> redirect(to: Routes.bike_path(conn, :rent))
      {:ok, _} ->  conn
                    |> put_flash(:info, "You have successfully rented the bike. Happy ride!")
                    |> redirect(to: Routes.page_path(conn, :index))
    end

  end



  def end_ride(conn, _params) do
    render(conn, "end.html")
  end

  def endit(conn, %{"id" => id, "dock_id" => dock_id}) do
    user = TartuBike.Authentication.load_current_user(conn)

    query =
      from r in Ride,
        where: r.bike_id == ^id and is_nil(r.ended_at),
        select: r

    ride = Repo.all(query) |> Repo.preload([:end_dock, :start_dock])

    case {ride, user.id} do
      {r, _} when r == [] ->
        conn
        |> put_flash(:error, "You haven't rented this bike")
        |> redirect(to: Routes.bike_path(conn, :end_ride))

      {_, uid} when uid == hd(ride).user_id ->
        case Repo.get(Dock, dock_id) do
          nil ->
            conn
            |> put_flash(:error, "The station doesn't exist")
            |> redirect(to: Routes.bike_path(conn, :end_ride))

          d ->
            case getTotalOpenDocks(dock_id) > 0 do
              true ->
                [distance] = Geolocation.distanceOfRide(hd(ride).start_dock_id, dock_id)
                Repo.update!(
                  Ecto.Changeset.change(hd(ride),
                    ended_at: DateTime.utc_now() |> DateTime.truncate(:second),
                    end_dock: d,
                    distance: distance
                  )
                )

                Repo.update!(
                  Repo.get(Bike, id)
                  |> Repo.preload(:dock)
                  |> Ecto.Changeset.change(status: "available", dock_id: d.id)
                )

                {fee, st, en, charged} = Fee.calculate(hd(ride).id)


                case charged == 0 do
                  false ->
                    conn
                    |> redirect(to: Routes.paymentservice_path(conn, :issue, bike_id: id, fee: fee, charged: charged))

                  true ->
                    invoicedate = DateTime.utc_now() |> DateTime.truncate(:second)
                    Repo.insert!(%Invoice{description: "fee: €#{fee}", invoice_date: invoicedate,  amount: fee, user_id: user.id})

                    u = Repo.get(User, uid)
                    balance = Decimal.sub(u.balance, fee)
                    u |> Ecto.Changeset.change(balance: balance)
                      |> Repo.update!
                    conn
                    |> put_flash(:info, "You have successfully ended the ride; Fee: €#{fee} Started: #{st} Ended: #{en}")
                    |> redirect(to: Routes.invoice_path(conn, :invoice))
                end


              false ->
                conn
                |> put_flash(:error, "No empty dock at this station")
                |> redirect(to: Routes.bike_path(conn, :end_ride))
            end
        end

      _ ->
        conn
        |> put_flash(:error, "You aren't authorised to end this ride")
        |> redirect(to: Routes.bike_path(conn, :rent))
    end
  end

  defp getTotalOpenDocks(station_id) do
    query =
      from bike in Bike,
        where: bike.dock_id == ^station_id,
        select: count(bike)

    cnt = Repo.one(query)

    query =
      from dock in Dock,
        where: dock.id == ^station_id,
        select: dock.capacity

    cap = Repo.one(query)

    cap - cnt
  end


  defp validate_bike_exists(bike, user) do
    case bike do
      nil -> {:error, %{reason: :wrong_bike_id}}
       _  -> {:ok, %{"bike" => bike, "user" => user}}
      end
  end

  defp validate_bike_available({:ok, %{"bike" => bike} = opts}) do
    case bike do
      b when b.status=="available" -> {:ok, opts}
       _  -> {:error, %{reason: :unavailable_bike}}
      end
  end

  defp validate_bike_available({:error, opts}), do: {:error, opts}


  defp validate_bike_available_or_booked({:ok, %{"bike" => bike} = opts}) do
    case bike do
      b when b.status=="available" -> {:ok, opts}
      b when  b.status=="booked" -> validate_booked_by_user_and_active({:ok, opts})
       _  -> {:error, %{reason: :unavailable_bike}}
      end
  end

  defp validate_bike_available_or_booked({:error, opts}), do: {:error, opts}


  defp validate_booked_by_user_and_active({:ok,%{"bike" => bike, "user" =>user} = opts}) do
    query = from b in Booking,
                  where: b.bike_id==^bike.id and b.user_id == ^user.id and b.status == "active",
                  select: b
    bookings = Repo.all(query)
    case bookings do
      [] -> {:error, %{reason: :unavailable_bike}}
      _ -> {:ok, opts |> Map.put("booking", bookings |> hd)}
    end
  end


  defp validate_time({:ok, opts}) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)
    case time do
      t when t.hour < 5 and t.hour > 1-> {:error, %{reason: :non_working_time}}
      _ -> {:ok,  opts |> Map.put("time", time)}
    end
  end

  defp validate_time({:error, opts}), do: {:error, opts}


  defp start_ride({:error, opts}), do: {:error, opts}

  defp start_ride({:ok, %{"bike" => bike, "user" =>user, "time" => time, "booking" => booking}=opts}) do
    Repo.update!(Ecto.Changeset.change(bike, status: "in-use", dock: nil))
    new_ride = Repo.insert!(%Ride{user: user, bike: bike, started_at: time, start_dock: bike.dock })
    Repo.update!(Ecto.Changeset.change(booking, status: "ended", ride_id: new_ride.id))
    {:ok, opts}
  end

  defp start_ride({:ok, %{"bike" => bike, "user" =>user, "time" => time}=opts}) do
    Repo.update!(Ecto.Changeset.change(bike, status: "in-use", dock: nil))
    Repo.insert!(%Ride{user: user, bike: bike, started_at: time, start_dock: bike.dock })
    {:ok, opts}
  end

  defp book_bike({:error, opts}), do: {:error, opts}

  defp book_bike({:ok, %{"bike" => bike, "user" =>user}=opts}) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)
    Repo.update!(Ecto.Changeset.change(bike, status: "booked"))
    Repo.insert!(%Booking{user: user, bike: bike, booked_at: time, status: "active"})
    {:ok, opts}
  end
end
