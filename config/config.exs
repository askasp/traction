# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :traction,
  ecto_repos: [Traction.Repo]

# Configures the endpoint
config :traction, TractionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Iynfe5f1vdHLwPKgqETH7Cv7WwkiLLHnMv8rw0GaeR2XH17PUDKnZZ6in8oKEKd0",
  render_errors: [view: TractionWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Traction.PubSub,
  live_view: [signing_salt: "gE9zSJwD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
