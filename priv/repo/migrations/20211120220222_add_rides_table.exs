defmodule TartuBike.Repo.Migrations.AddRidesTable do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :started_at, :utc_datetime
      add :ended_at, :utc_datetime
      add :user_id, references(:users)
      add :bike_id, references(:bikes)
      timestamps()
    end
  end
end
