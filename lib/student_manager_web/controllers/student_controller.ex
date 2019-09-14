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
    teacher = Repo.preload(conn.assigns.current_user, :teacher).teacher

    case Accounts.add_student(teacher, student_params) do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "student created successfully!")
        |> redirect(to: Routes.student_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    {:ok, student} = Accounts.get_student(id)
    {:ok, parents} = Accounts.get_parents(student)

    render(conn, "show.html", student: student, parents: parents)
  end

  def edit(conn, %{"id" => id}) do
    {:ok, student} = Accounts.get_student(id)
    changeset = Student.changeset(student, %{})

    render(conn, "edit.html", changeset: changeset, student: student)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    {:ok, student} = Accounts.get_student(id)

    case Accounts.update_student(student, student_params) do
      {:ok, _student} ->
        conn
        |> redirect(to: Routes.student_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", student: student, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, student} = Accounts.get_student(id)

    case Accounts.delete_student(student) do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student deleted successfully")
        |> redirect(to: Routes.student_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: Routes.student_path(conn, :index))
    end
  end
end
