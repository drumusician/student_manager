defmodule StudentManagerWeb.Router do
  use StudentManagerWeb, :router
  use Pow.Phoenix.Router

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
    pipe_through :browser
    get "/", StudentManagerWeb.PageController, :index
    live "/registration/new", StudentManagerWeb.UserRegistration
    pow_routes()
  end

  scope "/", StudentManagerWeb do
    pipe_through [:browser, :protected]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StudentManagerWeb do
  #   pipe_through :api
  # end
end
