import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

config :ex_unit,
  capture_log: true

# Configures the event store database
config :conduit, Conduit.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "conduit_eventstore_test",
  hostname: "localhost",
  pool_size: 1,
  show_sensitive_data_on_connection_error: true

# Configures the read store database
config :conduit, Conduit.Repo,
  migration_timestamps: [type: :utc_datetime_usec],
  username: "postgres",
  password: "postgres",
  database: "conduit_readstore_test",
  hostname: "localhost",
  pool_size: 1,
  show_sensitive_data_on_connection_error: true

config :bcrypt_elixir, :log_rounds, 4
