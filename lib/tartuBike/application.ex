defmodule TartuBike.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TartuBike.Repo,
      # Start the Telemetry supervisor
      TartuBikeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TartuBike.PubSub},
      # Start the Endpoint (http/https)
      TartuBikeWeb.Endpoint
      # Start a worker by calling: TartuBike.Worker.start_link(arg)
      # {TartuBike.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TartuBike.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TartuBikeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
