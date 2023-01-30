import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tartuBike, TartuBike.Repo,
  username: "postgres",
  password: "pass@123",
  database: "tartubike_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tartuBike, TartuBikeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  secret_key_base: "pzIJ1F+lPBmcWnYWiYc7qlDDtLcboWDgkfVTHMWrNFajh7cvMqVXVXKjDjxcBDgX",
  server: true

# In test we don't send emails.
config :tartuBike, TartuBike.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Add the following lines at the end of the file
config :hound, driver: "chrome_driver"
config :tartuBike, sql_sandbox: true
# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
