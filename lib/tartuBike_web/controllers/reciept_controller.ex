defmodule TartuBikeWeb.RecieptController do
  use TartuBikeWeb, :controller
  alias TartuBike.{Repo}
  import Ecto.Query, only: [from: 2]

  alias TartuBike.Accounts.Membership
  alias TartuBike.Accounts.Membershiptype

def reciept(conn, _param) do

  user = TartuBike.Authentication.load_current_user(conn)

  query = (from m in Membership,
          join: membershiptypes in Membershiptype,
          on:
          m.membershiptype_id == membershiptypes.id,
          where: m.user_id == ^user.id,
          select: m,
          order_by: [desc: m.id], limit: 1)

  receipt_invoice = Repo.all(query) |> Repo.preload([:membershiptype, :user])

  render(conn, "reciept.html", receipt_invoice: receipt_invoice)
end
end
