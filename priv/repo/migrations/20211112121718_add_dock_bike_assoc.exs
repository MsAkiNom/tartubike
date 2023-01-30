defmodule TartuBike.Repo.Migrations.AddDockBikeAssoc do
  use Ecto.Migration

  def change do
    alter table(:bikes) do
      add :dock_id, references(:docks)
    end
  end
end
