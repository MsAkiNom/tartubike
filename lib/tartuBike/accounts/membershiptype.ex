defmodule TartuBike.Accounts.Membershiptype do
  use Ecto.Schema
  import Ecto.Changeset

  schema "membershiptypes" do
    field :duration, :string
    field :amount, :decimal, default: 0.0
    field :description, :string
    timestamps()
  end

  @doc false
  def changeset(membershiptype, attrs) do
    membershiptype
    |> cast(attrs, [:duration, :amount, :description])
  end
end
