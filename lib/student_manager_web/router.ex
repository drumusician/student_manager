defmodule StudentManagerWeb.Router do
  use StudentManagerWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :student_manager

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    if Mix.env() == :dev do
      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end

    pipe_through :browser
    get "/", StudentManagerWeb.PageController, :index
    get "/pricing", StudentManagerWeb.PageController, :pricing
    live "/registration/new", StudentManagerWeb.UserRegistration
    pow_routes()
    pow_extension_routes()
  end

  scope "/", StudentManagerWeb do
    pipe_through [:browser, :protected]
    resources "/students", StudentController, only: [:index]
    resources "/dashboard", DashboardController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StudentManagerWeb do
  #   pipe_through :api
  # end
end
