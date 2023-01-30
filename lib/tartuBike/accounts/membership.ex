defmodule TartuBike.Accounts.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  alias TartuBike.Accounts.{User, Membershiptype}

  schema "memberships" do
    belongs_to :user, User
    belongs_to :membershiptype, Membershiptype

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :membershiptype_id])
  end
end
