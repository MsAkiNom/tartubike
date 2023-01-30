defmodule TartuBikeWeb.PageController do
  use TartuBikeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
