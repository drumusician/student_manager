use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :student_manager, StudentManagerWeb.Endpoint,
  http: [port: 4002],
  server: true

config :student_manager, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :student_manager, StudentManager.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "student_manager_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wallaby,
  js_errors: false,
  screenshot_on_failure: true,
  js_logger: :stdio,
  driver: Wallaby.Experimental.Chrome
