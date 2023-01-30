defmodule TartuBikeWeb.SessionController do
  use TartuBikeWeb, :controller

  alias TartuBike.Repo
  alias TartuBike.Accounts.User

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    user = Repo.get_by(User, username: username)
    case TartuBike.Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> TartuBike.Authentication.login(user)
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Bad Credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> TartuBike.Authentication.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
