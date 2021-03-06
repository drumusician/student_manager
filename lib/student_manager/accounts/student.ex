defmodule StudentManager.Accounts.Student do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias StudentManager.Accounts.{User, Teacher, TeacherStudent, Student}
  alias StudentManager.Repo

  schema "students" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:instrument, :string)
    field(:date_of_birth, :date)
    belongs_to(:user, User)

    many_to_many(:teachers, Teacher, join_through: TeacherStudent)

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:first_name, :last_name, :instrument, :date_of_birth])
  end

  def current_teacher(student) do
    from(t in Teacher,
      join: ts in TeacherStudent,
      where:
        t.id == ts.teacher_id and
          ts.current == ^true and
          ts.student_id == ^student.id
    )
  end

  def age(student) do
    query =
      from(s in Student,
        where: s.id == ^student.id,
        select: fragment("age(?)", s.date_of_birth)
      )

    (Repo.one(query).months / 12) |> trunc()
  end
end
