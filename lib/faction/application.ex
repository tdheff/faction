defmodule Faction.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Faction.Repo,
      # Start the Telemetry supervisor
      FactionWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Faction.PubSub},
      # Start the Endpoint (http/https)
      FactionWeb.Endpoint,
      # Start a worker by calling: Faction.Worker.start_link(arg)
      # {Faction.Worker, arg}
      Pow.Store.Backend.MnesiaCache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Faction.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FactionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
