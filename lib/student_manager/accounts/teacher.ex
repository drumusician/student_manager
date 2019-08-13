defmodule StudentManager.Accounts.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentManager.Accounts.User
  alias StudentManager.Accounts.Student
  alias StudentManager.Accounts.TeacherStudent

  schema "teachers" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:bio, :string)
    belongs_to(:user, User)
    many_to_many(:students, Student, join_through: TeacherStudent)

    timestamps()
  end

  def changeset(user_or_changeset, attrs \\ %{}) do
    user_or_changeset
    |> cast(attrs, [:first_name, :last_name, :bio])
  end
end
