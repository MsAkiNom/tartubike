defmodule TartuBike.Repo.Migrations.AddDistanceForRide do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add :distance, :decimal, default: 0.0
    end
  end
end
