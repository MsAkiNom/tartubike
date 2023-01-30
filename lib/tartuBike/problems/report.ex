defmodule TartuBike.Problems.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    belongs_to :bike, TartuBike.BikeSharing.Bike
    belongs_to :user, TartuBike.Accounts.User
    field :title, :string
    field :issue, :string
    field :reference, :string

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:bike_id, :title, :issue, :reference])
    |> validate_required([:bike_id, :title, :issue])
  end
end
