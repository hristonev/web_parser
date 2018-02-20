# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :frezu,
  ecto_repos: [Frezu.Repo]

# Configures the endpoint
config :frezu, Frezu.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8sUI4xDVlf2my9VznMcBUa2G4CFnlTQ8rJK5VCWisITNdvzGunw9XxlfPxoRpUnp",
  render_errors: [view: Frezu.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frezu.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
