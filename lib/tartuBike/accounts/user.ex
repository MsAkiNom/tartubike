defmodule TartuBike.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :creditcard, :string
    field :dateofbirth, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :tartubusnumber, :string
    field :username, :string
    field :hashed_password, :string
    field :balance, :decimal, default: 0.0
    has_many :memberships, TartuBike.Accounts.Membership

    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:name, :username, :password, :dateofbirth, :email, :creditcard, :tartubusnumber, :balance])
    |> unique_constraint(:username)
    |> hash_password()
    |> validate_required([:name, :username, :password, :dateofbirth, :email])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> validate_payment()
    |> validate_number(:balance, greater_than_or_equal_to: 0)

  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  defp validate_payment(changeset) do
    cc = get_field(changeset, :creditcard)
    bus = get_field(changeset, :tartubusnumber)
    if cc == nil && bus == nil do
      add_error(changeset, :tartubusnumber, "Please enter your payment method; credit card or bus card")
    else
      changeset |> validate_format(:creditcard, ~r/\d{16}/)
                |> validate_format(:tartubusnumber, ~r/\d{13}/)
    end
  end

end
