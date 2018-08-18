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

#Recaptcha plugin config, don't commit the keys!
config :recaptcha,
  public_key: {:system, "RECAPTCHA_PUBLIC_KEY"},
  secret: {:system, "RECAPTCHA_PRIVATE_KEY"}

config :hexedio, Hexedio.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: {:system, "SMTP_SERVER"},
  hostname: "localhost",
  port: 465,
  username: {:system, "SMTP_USERNAME"},
  password: {:system, "SMTP_PASSWORD"},
  tls: :never, # can be `:always` or `:never`
  allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"], # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: true, # can be `true`
  retries: 2,
  no_mx_lookups: false, # can be `true`
  auth: :always # can be `always`. If your smtp relay requires authentication set it to `always`.
