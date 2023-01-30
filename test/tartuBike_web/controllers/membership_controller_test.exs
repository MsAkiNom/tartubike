defmodule TartuBikeWeb.MembershipControllerTest do
  use TartuBikeWeb.ConnCase

  import TartuBike.AccountsFixtures

  @create_attrs %{desc: "some desc"}
  @update_attrs %{desc: "some updated desc"}
  @invalid_attrs %{desc: nil}



  describe "new membership" do
    test "renders form", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = get(conn, Routes.membership_path(conn, :new))
      assert html_response(conn, 200) =~ "New Membership"
    end
  end

  describe "delete membership" do
    setup [:create_membership]

    test "deletes chosen membership", %{conn: conn, membership: membership} do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "kenny", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)
      conn = delete(conn, Routes.membership_path(conn, :delete, membership))
      assert redirected_to(conn) == Routes.membership_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.membership_path(conn, :show, membership))
      end
    end
  end

  defp create_membership(_) do
    membership = membership_fixture()
    %{membership: membership}
  end
end
