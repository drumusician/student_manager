use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :student_manager, StudentManagerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :student_manager, Studentmanager.Repo,
  username: "postgres",
  password: "postgres",
  database: "student_manager_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
