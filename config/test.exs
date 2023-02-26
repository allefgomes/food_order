import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :food_order, FoodOrder.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOSTNAME") || "localhost",
  database: "food_order_test#{System.get_env("MIX_TEST_PARTITION")}",
  port: System.get_env("DB_PORT"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :food_order, FoodOrderWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NrNJCEh62ouVTQHOZnml/3RiPNXf1Co6ZrV560Cb40o1EZJv2VVzl4zOx7VBEESy",
  server: false

config :waffle,
  storage: Waffle.Storage.Local

# In test we don't send emails.
config :food_order, FoodOrder.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
