defmodule StudentManagerWeb.StudentController do
  use StudentManagerWeb, :controller
  alias StudentManager.Accounts
  alias StudentManager.Accounts.Student
  alias StudentManager.Repo

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    students = Accounts.get_students(current_user)
    changeset = Student.changeset(%Student{}, %{})

    render(conn, "index.html", students: students, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Student.changeset(%Student{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"student" => student_params}) do
    changeset = Student.changeset(%Student{}, student_params)
    students = Accounts.get_students(conn.assigns.current_user)
    teacher = Repo.preload(conn.assigns.current_user, :teacher).teacher

    case Accounts.add_student(teacher, student_params) do
      {:ok, student } ->
        conn
        |> put_flash(:info, "student created successfully!")
        |> redirect(to: Routes.student_path(conn, :index))
      {:error, changeset}->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
