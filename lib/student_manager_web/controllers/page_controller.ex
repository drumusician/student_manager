defmodule StudentManagerWeb.PageController do
  use StudentManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
