defmodule TartuBike.Repo.Migrations.CreateDocks do
  use Ecto.Migration

  def change do
    create table(:docks) do
      add :name, :string
      add :capacity, :integer
      add :location, :string
      timestamps()
    end
  end
end
