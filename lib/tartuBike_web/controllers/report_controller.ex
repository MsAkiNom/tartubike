defmodule TartuBikeWeb.ReportController do
  use TartuBikeWeb, :controller

  alias TartuBike.Problems
  alias TartuBike.Problems.Report

  alias TartuBike.Repo
  alias Ecto.{Changeset}

  def index(conn, _params) do
    reports = Problems.list_reports()
    render(conn, "index.html", reports: reports)
  end

  def new(conn, _params) do
    changeset = Problems.change_report(%Report{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"report" => report_params}) do
    user = TartuBike.Authentication.load_current_user(conn)
    d = DateTime.utc_now()
    ref = "#{user.id}-#{d.year}#{d.month}#{d.day}#{d.hour}#{d.minute}#{d.second}"

    changeset = Report.changeset(%Report{}, report_params)
                |> Changeset.put_change(:user, user)
                |> Changeset.put_change(:reference, ref)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "REF: #{ref} | Report created successfully." )
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Problems.get_report!(id)
    render(conn, "show.html", report: report)
  end

  def edit(conn, %{"id" => id}) do
    report = Problems.get_report!(id)
    changeset = Problems.change_report(report)
    render(conn, "edit.html", report: report, changeset: changeset)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Problems.get_report!(id)

    case Problems.update_report(report, report_params) do
      {:ok, report} ->
        conn
        |> put_flash(:info, "Report updated successfully.")
        |> redirect(to: Routes.report_path(conn, :show, report))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", report: report, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Problems.get_report!(id)
    {:ok, _report} = Problems.delete_report(report)

    conn
    |> put_flash(:info, "Report deleted successfully.")
    |> redirect(to: Routes.report_path(conn, :index))
  end
end
