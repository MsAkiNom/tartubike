defmodule TartuBikeWeb.MembershipController do
  use TartuBikeWeb, :controller

  alias TartuBike.Accounts
  alias TartuBike.Accounts.Membership
  alias TartuBike.Accounts.Membershiptype
  alias TartuBike.{Repo, Invoices.Invoice}

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    # memberships = Accounts.list_memberships()
    # render(conn, "index.html", memberships: memberships)
    user = TartuBike.Authentication.load_current_user(conn)
    memberships = Repo.all(from m in Membership, where: m.user_id == ^user.id)
    render conn, "index.html", memberships: memberships
  end

  def new(conn, _params) do

    user = TartuBike.Authentication.load_current_user(conn)

    currentmembership = Repo.all(from m in Membership,
    join: membershiptypes in Membershiptype,
            on:
            m.membershiptype_id == membershiptypes.id,
            where: m.user_id == ^user.id,
            order_by: [desc: m.id], limit: 1)
            |> Repo.preload([:membershiptype])

    membershiptypes = Repo.all(from a in Membershiptype, select: {a.description, a.id})
    changeset = Accounts.change_membership(%Membership{})
    render(conn, "new.html", changeset: changeset,  membershiptypes: membershiptypes, currentmembership: currentmembership)
  end

  def create(conn, %{"membership" => membership_params}) do
    selectedId = String.to_integer(membership_params["membershiptype_id"])
    user = TartuBike.Authentication.load_current_user(conn)
    query =
      from r in Membershiptype,
        where: r.id == ^selectedId,
        select: {r.amount, r.description}

    {amount, desc} = Repo.one(query)

    # IO.inspect(query)
    updateBalance(amount, conn)
    Repo.insert!(%Membership{membershiptype_id: selectedId, user_id: user.id})

    invoicedate = DateTime.utc_now() |> DateTime.truncate(:second)
    Repo.insert!(%Invoice{description: desc, invoice_date: invoicedate,  amount: amount, user_id: user.id})

    conn
    |> put_flash(:info, "Membership save successfully.")
    |> redirect(to: Routes.invoice_path(conn, :invoice))
    # |> redirect(to: Routes.reciept_path(conn, :reciept))
  end

  defp updateBalance(amount, conn) do
    u = TartuBike.Authentication.load_current_user(conn)
    balance = Decimal.sub(u.balance, amount)
    u
    |> Ecto.Changeset.change(balance: balance)
    |> Repo.update()
  end

  def show(conn, %{"id" => id}) do
    membership = Accounts.get_membership!(id)
    render(conn, "show.html", membership: membership)
  end

  def edit(conn, %{"id" => id}) do
    membership = Accounts.get_membership!(id)
    changeset = Accounts.change_membership(membership)
    render(conn, "edit.html", membership: membership, changeset: changeset)
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Accounts.get_membership!(id)

    case Accounts.update_membership(membership, membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "Membership updated successfully.")
        |> redirect(to: Routes.membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", membership: membership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership = Accounts.get_membership!(id)
    {:ok, _membership} = Accounts.delete_membership(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: Routes.membership_path(conn, :index))
  end



end
