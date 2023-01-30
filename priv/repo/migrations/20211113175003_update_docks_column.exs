defmodule TartuBike.Repo.Migrations.UpdateDocksColumn do
  use Ecto.Migration

  def change do
    alter table(:docks) do
      add :latitude, :decimal
      add :longitude, :decimal
    end
  end
end
