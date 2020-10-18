# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hbits,
  ecto_repos: [Hbits.Repo]

# Configures the endpoint
config :hbits, HbitsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iACoozJR+lef8JarM2sy9p98LxYafWn5mJi+jM4NZxEgRtDuzxKEhXqZf/WZ5B4r",
  render_errors: [view: HbitsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hbits.PubSub,
  live_view: [signing_salt: "noXAU+Ks"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# POW Auth
config :hbits, :pow,
  user: Hbits.Users.User,
  repo: Hbits.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: HbitsWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
