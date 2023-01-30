defmodule TartuBike.Repo.Migrations.AddRoutesTable do
  use Ecto.Migration

  def change do
    create table(:routes) do
      add :name, :string
      add :img, :string
      add :start_dock_id, references(:docks, on_delete: :nothing)
      add :end_dock_id, references(:docks, on_delete: :nothing)

      timestamps()
    end

    create index(:routes, [:start_dock_id])
    create index(:routes, [:end_dock_id])
  end
end
