defmodule TartuBike.Repo.Migrations.AddDockidToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add :start_dock_id, references(:docks)
      add :end_dock_id, references(:docks)
    end
  end
end
