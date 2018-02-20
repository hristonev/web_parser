use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :frezu, Frezu.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :frezu, Frezu.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "frezu_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
