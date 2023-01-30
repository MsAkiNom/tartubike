defmodule TartuBikeWeb.ReportControllerTest do
  use TartuBikeWeb.ConnCase

  import TartuBike.ProblemsFixtures

  @create_attrs %{bike_id: 42, issue: "some issue", title: "some title"}
  @update_attrs %{bike_id: 43, issue: "some updated issue", title: "some updated title"}
  @invalid_attrs %{bike_id: nil, issue: nil, title: nil}

  describe "index" do
    test "lists all reports", %{conn: conn} do

      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = get(conn, Routes.report_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Reports"
    end
  end

  describe "new report" do
    test "renders form", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = get(conn, Routes.report_path(conn, :new))
      assert html_response(conn, 200) =~ "New Report"
    end
  end

  describe "create report" do
    test "redirects to home when data is valid", %{conn: conn} do

      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = post(conn, Routes.report_path(conn, :create), report: @create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = post(conn, Routes.report_path(conn, :create), report: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Report"
    end
  end

  describe "edit report" do
    setup [:create_report]

    test "renders form for editing chosen report", %{conn: conn, report: report} do
      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = get(conn, Routes.report_path(conn, :edit, report))
      assert html_response(conn, 200) =~ "Edit Report"
    end
  end

  describe "update report" do
    setup [:create_report]

    test "redirects when data is valid", %{conn: conn, report: report} do

      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = put(conn, Routes.report_path(conn, :update, report), report: @update_attrs)
      assert redirected_to(conn) == Routes.report_path(conn, :show, report)

      conn = get(conn, Routes.report_path(conn, :show, report))
      assert html_response(conn, 200) =~ "some updated issue"
    end

    test "renders errors when data is invalid", %{conn: conn, report: report} do

      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = put(conn, Routes.report_path(conn, :update, report), report: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Report"
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report} do

      conn = post(conn, Routes.user_path(conn, :create, %{"user" => %{"creditcard" => "1234123412341234", "dateofbirth" => "2012-12-02", "email" => "asdf@fasdf.com", "name" => "Monika", "password" => "askdjflkasdj", "tartubusnumber" => "", "username" => "ajlksdjfl"}}))
      conn = post(conn, Routes.session_path(conn, :create), %{"session" => %{"username" => "ajlksdjfl", "password" => "askdjflkasdj"}})
      conn = get conn, redirected_to(conn)

      conn = delete(conn, Routes.report_path(conn, :delete, report))
      assert redirected_to(conn) == Routes.report_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.report_path(conn, :show, report))
      end
    end
  end

  defp create_report(_) do
    report = report_fixture()
    %{report: report}
  end
end
