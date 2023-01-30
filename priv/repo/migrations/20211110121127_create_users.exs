defmodule TartuBike.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :password, :string
      add :dateofbirth, :string
      add :email, :string
      add :creditcard, :string
      add :tartubusnumber, :string

      timestamps()
    end
  end
end
