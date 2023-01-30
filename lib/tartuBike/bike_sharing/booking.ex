defmodule TartuBike.BikeSharing.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias TartuBike.Accounts.User
  alias TartuBike.BikeSharing.{Bike, Ride}

  schema "bookings" do
    belongs_to :user, User
    belongs_to :bike, Bike
    belongs_to :ride, Ride
    field :booked_at, :utc_datetime
    field :status, :string
    timestamps()
  end

  @doc false
  def changeset(bike, attrs) do
    bike
    |> cast(attrs, [:user, :bike, :status, :booked_at, :ride])
    |> validate_required([:user, :bike, :status])
  end
end
