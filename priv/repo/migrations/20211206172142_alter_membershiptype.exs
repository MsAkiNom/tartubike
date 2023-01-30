defmodule TartuBike.Repo.Migrations.AlterMembershiptype do
  use Ecto.Migration

  def change do
    alter table(:membershiptypes) do
      remove :desc
    end
  end
end
