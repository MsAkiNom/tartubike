defmodule TartuBike.Repo.Migrations.AddReferenceReportIssue do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      add :reference, :string
      add :user_id, references(:users)
      add :bike_id, references(:bikes)
      remove :bikeid
    end
  end
end
