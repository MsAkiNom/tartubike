defmodule TartuBikeWeb.UsersummaryControllerTest do
  use TartuBikeWeb.ConnCase
  use Ecto.Schema

  alias TartuBike.{BikeSharing.Ride, Repo}

  test "see an estimate of user usage", %{conn: conn}do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})

      conn = get(conn, Routes.usersummary_path(conn, :userusage))
      assert html_response(conn, 200) =~ "User Usage"
  end

  test "see an history of ride made", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})

    conn = get(conn, Routes.usersummary_path(conn, :ridehistory))
    assert html_response(conn, 200) =~ "Ride History"
  end

  test "see a history of invoice", %{conn: conn}do
    conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
    conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})

    conn = get(conn, Routes.usersummary_path(conn, :invoicehistory))
    assert html_response(conn, 200) =~ "Invoice History"
  end

end
