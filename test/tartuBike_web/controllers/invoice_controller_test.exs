defmodule TartuBikeWeb.InvoiceControllerTest do
    use TartuBikeWeb.ConnCase
    use Ecto.Schema
  
    alias TartuBike.{Repo, Accounts.User}
    alias TartuBike.BikeSharing.{Ride, Dock, Bike}

    test "see an invoice", %{conn: conn}do
        conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
        conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})



        dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu", capacity: 5})
        dock2 = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 25, 51329, Tartu", capacity: 5})
        bike1 = Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
        Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})


        user = Repo.get_by(User, email: "asdf@fasdf.com")
        Repo.insert!(%Ride{user: user, bike: bike1, started_at: DateTime.utc_now|>DateTime.truncate(:second)})
        conn = post(conn, Routes.bike_path(conn, :endit), %{id: bike1.id, dock_id: dock2.id})

        updated_bike = Repo.get!(Bike, bike1.id)

        conn = get conn, redirected_to(conn)
        assert assert html_response(conn, 200) =~ ~r/Invoice/

    end 
end