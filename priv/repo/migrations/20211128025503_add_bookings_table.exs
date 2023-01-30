defmodule TartuBike.Repo.Migrations.AddBookingsTable do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :booked_at, :utc_datetime
      add :user_id, references(:users)
      add :bike_id, references(:bikes)
      timestamps()
    end
  end
end
