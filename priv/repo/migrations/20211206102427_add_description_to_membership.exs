defmodule TartuBike.Repo.Migrations.AddDescriptionToMembership do
  use Ecto.Migration

  def change do
    alter table(:membershiptypes) do
      add :description, :string
    end
  end
end
