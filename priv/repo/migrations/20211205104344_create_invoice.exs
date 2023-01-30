defmodule TartuBike.Repo.Migrations.CreateInvoice do
  use Ecto.Migration

  def change do

    create table(:invoice) do
      add :description, :string
      add :amount, :decimal, default: 0.0
      add :invoice_date, :utc_datetime
      add :user_id, references(:users)
      add :ride_id, references(:rides)

      timestamps()
    end

  end
end
