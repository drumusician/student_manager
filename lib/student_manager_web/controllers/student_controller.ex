defmodule StudentManagerWeb.StudentController do
  use StudentManagerWeb, :controller
  alias StudentManager.Accounts

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    students = Accounts.get_students(current_user)

    render(conn, "index.html", students: students)
  end
end
