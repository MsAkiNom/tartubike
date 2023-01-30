defmodule TartuBike.BikeSharing.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    belongs_to :user, TartuBike.Accounts.User
    belongs_to :bike, TartuBike.BikeSharing.Bike
    belongs_to :start_dock, TartuBike.BikeSharing.Dock
    belongs_to :end_dock, TartuBike.BikeSharing.Dock
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime
    field :distance, :decimal
    timestamps()
  end

  @doc false
  def changeset(bike, attrs) do
    bike
    |> cast(attrs, [:user, :bike, :started_at, :ended_at, :start_dock_id, :end_dock_id])
    |> validate_required([:user, :bike])
  end
end
