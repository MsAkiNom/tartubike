defmodule TartuBikeWeb.PaymentserviceController do
  use TartuBikeWeb, :controller
  alias TartuBike.{Repo, Problems.Report, Invoices.Invoice}
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def issue(conn, _params) do
    render(conn, "issue.html")
  end

  def issueCheck(conn, %{"ref" => ref, "bike_id" => bike_id, "fee" => fee, "charged" => _charged}) do
    user = TartuBike.Authentication.load_current_user(conn)
    query =
      from r in Report,
        where: r.reference == ^ref and r.bike_id == ^bike_id and r.user_id == ^user.id,
        select: r

    case Repo.all(query) do
      [_] ->
        invoicedate = DateTime.utc_now() |> DateTime.truncate(:second)
        Repo.insert!(%Invoice{description: "fee: €#{fee}", invoice_date: invoicedate,  amount: Decimal.new(fee), user_id: user.id})

        updateBalance(Decimal.new(fee), conn)
        conn
          |> put_flash(:info, "You have successfully ended the ride; Fee: €#{fee}")
          |> redirect(to: Routes.invoice_path(conn, :invoice))
      _ ->
        conn
          |> put_flash(:error, "No report issues found! Bike id: #{bike_id}")
          |> render("issue.html")
    end
  end

  def issuePay(conn, %{"fee" => fee, "charged" => charged}) do
    user = TartuBike.Authentication.load_current_user(conn)
    amount = Decimal.add(Decimal.new(fee), Decimal.new(charged))

    invoicedate = DateTime.utc_now() |> DateTime.truncate(:second)
    Repo.insert!(%Invoice{description: "fee: €#{fee} with delay or missing bike charged: €#{charged}", invoice_date: invoicedate,  amount: amount, user_id: user.id})

    updateBalance(amount, conn)
    conn
    |> put_flash(:info, "You have successfully ended the ride; Fee: €#{fee} Charged: €#{charged}")
    |> redirect(to: Routes.invoice_path(conn, :invoice))
  end

  def addBalance(conn, %{"amount" => amount}) do
    amt = Decimal.new(amount)
    updateBalance(amt, conn, false)
    conn
    |> put_flash(:info, "Balance added")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp updateBalance(amount, conn, sub \\ true) do
    u = TartuBike.Authentication.load_current_user(conn)
    balance = if sub, do: Decimal.sub(u.balance, amount), else: Decimal.add(u.balance, amount)
    u |> Ecto.Changeset.change(balance: balance)
      |> Repo.update!
  end

end
