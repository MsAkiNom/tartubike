defmodule TartuBike.Repo.Migrations.CreateBikes do
  use Ecto.Migration

  def change do
    create table(:bikes) do
      add :status, :string
      add :type, :string
      timestamps()
    end
  end
end
