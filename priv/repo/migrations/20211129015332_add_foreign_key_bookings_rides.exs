defmodule TartuBike.Repo.Migrations.AddForeignKeyBookingsRides do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :ride_id, references(:rides)
    end
  end
end
