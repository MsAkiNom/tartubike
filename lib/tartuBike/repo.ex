defmodule TartuBike.Repo do
  use Ecto.Repo,
    otp_app: :tartuBike,
    adapter: Ecto.Adapters.Postgres
end
