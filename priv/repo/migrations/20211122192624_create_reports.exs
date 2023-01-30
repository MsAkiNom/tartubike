defmodule TartuBike.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :bikeid, :integer
      add :title, :string
      add :issue, :string

      timestamps()
    end
  end
end
