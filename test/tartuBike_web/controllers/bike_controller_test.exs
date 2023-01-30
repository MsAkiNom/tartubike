defmodule TartuBikeWeb.BikeControllerTest do
  use TartuBikeWeb.ConnCase
  use Ecto.Schema

  alias TartuBike.{Repo, Accounts.User}
  alias TartuBike.BikeSharing.{Dock, Bike, Ride, Booking}



  test "Logging in and renting a bike with confirmation", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Ramil", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
    conn = get conn, redirected_to(conn)


    dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu"})
    bike1 = Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
    Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})


    conn = post(conn, Routes.bike_path(conn, :rentit), %{id: bike1.id})
    updated_bike = Repo.get!(Bike, bike1.id)

    assert updated_bike.status == "in-use"
    assert length(Repo.preload(dock, :bikes).bikes)==1

    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200)
    assert assert html_response(conn, 200) =~ ~r/Happy ride/
   end


  test "Logging in and renting a bike with rejection", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Ramil", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
    conn = get conn, redirected_to(conn)

    dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu"})
    Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
    bike2 = Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})

    conn = post(conn, Routes.bike_path(conn, :rentit), %{id: (bike2.id+1)})

    conn = get conn, redirected_to(conn)
    assert assert html_response(conn, 200) =~ ~r/Failed to rent the bike/
   end


  test "Logging in and ending the ride with confirmation", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Ramil", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl", "balance" => 200.0}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
    conn = get conn, redirected_to(conn)

    dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu", capacity: 5})
    dock2 = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 25, 51329, Tartu", capacity: 5})
    bike1 = Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
    Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})


    assert length(Repo.preload(dock, :bikes).bikes)==2
    user = Repo.get_by(User, email: "asdf@fasdf.com")
    Repo.insert!(%Ride{user: user, bike: bike1, started_at: DateTime.utc_now|>DateTime.truncate(:second)})
    conn = post(conn, Routes.bike_path(conn, :endit), %{id: bike1.id, dock_id: dock2.id})

    updated_bike = Repo.get!(Bike, bike1.id)

    assert updated_bike.status == "available"
    assert length(Repo.preload(dock2, :bikes).bikes)==1
    conn = get conn, redirected_to(conn)
    assert assert html_response(conn, 200) =~ ~r/You have successfully ended the ride/
   end

   test "Logging in and renting a booked bike with confirmation", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Ramil", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
    conn = get conn, redirected_to(conn)


    dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu"})
    bike1 = Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
    Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})


    conn = post(conn, Routes.bike_path(conn, :bookit), %{id: bike1.id})
    updated_bike = Repo.get!(Bike, bike1.id)
    booking = Repo.get_by(Booking, bike_id: bike1.id)|> Repo.preload(:user)


    assert updated_bike.status == "booked"
    assert booking.user.email == "asdf@fasdf.com"
    assert booking.status == "active"




    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200)
    assert assert html_response(conn, 200) =~ ~r/You have successfully booked/
   end

   # Booking

   test "Logging in and booking a bike with confirmation", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Ramil", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
    conn = get conn, redirected_to(conn)


    dock = Repo.insert!(%Dock{status: "available", location: "Muuseumi tee 2, 51009, Tartu"})
    bike1 = Repo.insert!(%Bike{status: "available", type: "electric", dock: dock})
    Repo.insert!(%Bike{status: "available", type: "classic", dock: dock})


    conn = post(conn, Routes.bike_path(conn, :bookit), %{id: bike1.id})
    updated_bike = Repo.get!(Bike, bike1.id)
    booking = Repo.get_by(Booking, bike_id: bike1.id)|> Repo.preload(:user)


    assert updated_bike.status == "booked"
    assert booking.user.email == "asdf@fasdf.com"
    assert booking.status == "active"

    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200)
    assert assert html_response(conn, 200) =~ ~r/You have successfully booked/

    conn = post(conn, Routes.bike_path(conn, :rentit), %{id: bike1.id})
    updated_bike = Repo.get!(Bike, bike1.id)

    assert updated_bike.status == "in-use"
    updated_booking = Repo.get(Booking, booking.id)
    assert updated_booking.status == "ended"
    assert length(Repo.preload(dock, :bikes).bikes)==1

    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200)
    assert assert html_response(conn, 200) =~ ~r/Happy ride/
   end

end
