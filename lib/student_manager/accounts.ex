defmodule StudentManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias StudentManager.Repo

  alias StudentManager.Accounts.User
  alias StudentManager.Accounts.Teacher
  alias StudentManager.Accounts.Student
  alias StudentManager.Accounts.Parent

  @doc """
  Returns the list of users.

  ## Examples

  iex> list_users()
  [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

  iex> get_user!(123)
  %User{}

  iex> get_user!(456)
  ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

  iex> create_user(%{field: value})
  {:ok, %User{}}

  iex> create_user(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_user(%{type: "student"} = attrs), do: create_student(attrs)
  def create_user(%{type: "teacher"} = attrs), do: create_teacher(attrs)

  @doc """
  Creates a teacher.

  ## Examples

  iex> create_teacher(%{field: value})
  {:ok, %User{}}

  iex> create_teacher(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_teacher(attrs \\ %{}) do
    %User{}
    |> User.teacher_registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a student.

  ## Examples

  iex> create_student(%{field: value})
  {:ok, %User{}}

  iex> create_student(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %User{}
    |> User.student_registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Add a student to a teacher. This is most likely a teacher adding his/her students into the system.

  """

  def add_student(teacher, student_params) do
    {:ok, student} =
      Student.changeset(%Student{}, student_params)
      |> Repo.insert()

    teacher = Repo.preload(teacher, :students)

    teacher
    |> Teacher.changeset(%{})
    |> Ecto.Changeset.put_assoc(:students, [student | teacher.students])
    |> Repo.update()
  end

  @doc """
  Get student
  """

  def get_student(id) do
    student = Repo.get_by(Student, id: id)
    {:ok, student}
  end

  @doc """
  Get my students
  """

  def get_students(current_user) do
    user = Repo.preload(current_user, :teacher)
    teacher = Repo.preload(user.teacher, :students)
    teacher.students
  end

  @doc """
  update student
  """

  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  update student
  """

  def delete_student(student) do
    student
    |> Repo.delete()
  end

  @doc """
  Updates a user.

  ## Examples

  iex> update_user(user, %{field: new_value})
  {:ok, %User{}}

  iex> update_user(user, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

  iex> delete_user(user)
  {:ok, %User{}}

  iex> delete_user(user)
  {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

  iex> change_user(user)
  %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Get parents for a student.

  """

  def get_parents(student) do
    student = Repo.preload(student, :parents)
    {:ok, student.parents}
  end

  @doc """
  Gets a single parent.

  Raises `Ecto.NoResultsError` if the Parent does not exist.

  ## Examples

  iex> get_parent!(123)
  %Parent{}

  iex> get_parent!(456)
  ** (Ecto.NoResultsError)

  """
  def get_parent!(id), do: Repo.get!(Parent, id)

  @doc """
  Creates a parent.

  ## Examples

  iex> create_parent(%{field: value})
  {:ok, %Parent{}}

  iex> create_parent(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_parent(attrs \\ %{}) do
    %Parent{}
    |> Parent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parent.

  ## Examples

  iex> update_parent(parent, %{field: new_value})
  {:ok, %Parent{}}

  iex> update_parent(parent, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_parent(%Parent{} = parent, attrs) do
    parent
    |> Parent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Parent.

  ## Examples

  iex> delete_parent(parent)
  {:ok, %Parent{}}

  iex> delete_parent(parent)
  {:error, %Ecto.Changeset{}}

  """
  def delete_parent(%Parent{} = parent) do
    Repo.delete(parent)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parent changes.

  ## Examples

  iex> change_parent(parent)
  %Ecto.Changeset{source: %Parent{}}

  """
  def change_parent(%Parent{} = parent) do
    Parent.changeset(parent, %{})
  end
end
