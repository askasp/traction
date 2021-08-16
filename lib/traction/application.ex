defmodule Traction.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Traction.Repo,
      # Start the Telemetry supervisor
      {Finch, name: MyFinch},
      Traction.DiscordPoller,
      TractionWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Traction.PubSub},
      # Start the Endpoint (http/https)
      TractionWeb.Endpoint
      # Start a worker by calling: Traction.Worker.start_link(arg)
      # {Traction.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Traction.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TractionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
