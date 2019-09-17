defmodule StudentManagerWeb.PageController do
  use StudentManagerWeb, :controller
  plug :put_layout, false

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: "/dashboard")
    end

    render(conn, "index.html")
  end

  def pricing(conn, _params) do
    render(conn, "pricing.html")
  end
end
