defmodule TartuBike.BikeSharing.Bike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bikes" do
    field :status, :string
    field :type, :string
    belongs_to :dock, TartuBike.BikeSharing.Dock, on_replace: :update
    timestamps()
  end

  @doc false
  def changeset(bike, attrs) do
    bike
    |> cast(attrs, [:type, :status, :dock_id])
    |> validate_required([:type, :status])
    |> validate_inclusion(:type, ["electric", "classic"])
    |> validate_inclusion(:status, ["available", "in-use", "booked", "off-duty"])
  end
end
