defmodule TartuBike.BikeSharing.Route do
  use Ecto.Schema
  import Ecto.Changeset

  schema "routes" do
    field :img, :string
    field :name, :string
    belongs_to :start_dock, TartuBike.BikeSharing.Dock
    belongs_to :end_dock, TartuBike.BikeSharing.Dock

    timestamps()
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [:name, :img, :start_dock_id, :end_dock_id])
    |> validate_required([:name, :img, :start_dock_id, :end_dock_id])
  end
end
