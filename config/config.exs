import Config

# General application configuration
config :conduit,
  ecto_repos: [Conduit.Repo],
  event_stores: [Conduit.EventStore]

config :conduit, Conduit.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Conduit.EventStore
  ],
  pub_sub: :local,
  registry: :local

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [formats: [json: ConduitWeb.ErrorJSON]],
  pubsub_server: Conduit.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Conduit.Repo

config :phoenix, :json_library, Jason

config :vex,
  sources: [
    Conduit.Accounts.Validators,
    Conduit.Blog.Validators,
    Conduit.Support.Validators,
    Vex.Validators
  ]

config :conduit, Conduit.Auth.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Conduit",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "IOjbrty1eMEBzc5aczQn0FR4Gd8P9IF1cC7tqwB7ThV/uKjS5mrResG1Y0lCzTNJ"

import_config "#{config_env()}.exs"
