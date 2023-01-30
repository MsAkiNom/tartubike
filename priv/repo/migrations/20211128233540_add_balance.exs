defmodule TartuBike.Repo.Migrations.AddBalance do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal, default: 0.0
    end
  end
end
