# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hexedio,
  ecto_repos: [Hexedio.Repo]

# Configures the endpoint
config :hexedio, HexedioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6M0NM5W7bG+tlWm62BkSdnhrzEH9QYYEEmaBvzayL5JrtH+I6icsygU+ONAFgdBM",
  render_errors: [view: HexedioWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hexedio.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure Guardian
config :hexedio, Hexedio.Auth.Guardian,
  issuer: "Hexed", #App name
  secret_key: "l7nYTevAn4PHyuHlCfK9zmkvJ/nKjN1VjVZGvGZBSqpU+GhsqfSEMCaMvpyhA4nB" #mix guardian.gen.secret

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
