import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
port = System.fetch_env!("PORT")
hostname = System.fetch_env!("HOSTNAME")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")
sendgrid_api_key = System.fetch_env!("SENDGRID_API_KEY")

config :student_manager, StudentManager.Repo,
  username: db_user,
  password: db_password,
  database: "student_manager_prod",
  hostname: db_host,
  pool_size: 10

config :student_manager, StudentManagerWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base,
  check_origin: false

config :student_manager, StudentmanagerWeb.Endpoint, server: true

config :student_manager, StudentManager.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: sendgrid_api_key
