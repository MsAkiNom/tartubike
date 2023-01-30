defmodule TartuBikeWeb.InvoiceController do
    use TartuBikeWeb, :controller
    alias TartuBike.{Repo, BikeSharing.Ride, BikeSharing.Bike, Accounts.User, Invoices.Invoice}
    import Ecto.Query, only: [from: 2]


    def invoice(conn, _param) do

        user = TartuBike.Authentication.load_current_user(conn)
          query = from inv in Invoice ,
                  join: user in User,
                  on:
                  inv.user_id == user.id,
                  where: inv.user_id == ^user.id,
                  order_by: [desc: :invoice_date],
                  select: inv


      invoice = Repo.all(query) |> Repo.preload([:user]) |>  hd
      render(conn, "index.html", invoice: invoice)
    end


  end
