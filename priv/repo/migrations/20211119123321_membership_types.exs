defmodule TartuBike.Repo.Migrations.MembershipTypes do
  use Ecto.Migration

  def change do
    create table(:membershiptypes) do
      add :desc, :string
      add :duration, :string
      add :amount, :decimal, default: 0.0

      timestamps()
    end
  end
end
