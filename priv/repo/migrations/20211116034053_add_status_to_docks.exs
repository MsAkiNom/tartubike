defmodule TartuBike.Repo.Migrations.AddStatusToDocks do
  use Ecto.Migration

  def change do
    alter table(:docks) do
      add :status, :string
    end
  end
end
