defmodule TartuBike.Invoices.Invoice do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "invoice" do
      belongs_to :ride, TartuBike.BikeSharing.Ride
      belongs_to :user, TartuBike.Accounts.User
      field :invoice_date, :utc_datetime
      field :description, :string
      field :amount, :decimal
  
      timestamps()
    end
  
    @doc false
    def changeset(invoice, attrs) do
      invoice
      |> cast(attrs, [:invoice_date, :description, :amount])
    end
  end
  