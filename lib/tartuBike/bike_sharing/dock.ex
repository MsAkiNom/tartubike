defmodule TartuBike.BikeSharing.Dock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "docks" do
    field :name, :string
    field :capacity, :integer
    field :location, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :status, :string
    field :distance, :float, virtual: true
    has_many :bikes, TartuBike.BikeSharing.Bike
    timestamps()
  end

  @doc false
  def changeset(dock, attrs) do
    dock
    |> cast(attrs, [:name, :capacity,:latitude, :longitude])
    |> validate_required([:name, :capacity])
    |> validate_number(:capacity, greater_than_or_equal_to: 0)
  end
end
