defmodule TartuBike.Repo.Migrations.AlterMembership do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      remove :desc
      add :membershiptype_id, references(:membershiptypes)
    end
  end
end
