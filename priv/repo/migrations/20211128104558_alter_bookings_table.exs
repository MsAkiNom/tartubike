defmodule TartuBike.Repo.Migrations.AlterBookingsTable do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :status, :string
    end
  end
end
