defmodule TartuBike.Guardian do
  use Guardian, otp_app: :tartuBike

  alias TartuBike.Accounts.User
  alias TartuBike.Repo

  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_), do: {:error, :resource_not_found}

  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
