defmodule StudentManager.Accounts.Student do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias StudentManager.Accounts.{User, Teacher, TeacherStudent, Student, ParentStudent, Parent}
  alias StudentManager.Repo

  schema "students" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:instrument, :string)
    field(:date_of_birth, :date)
    belongs_to(:user, User)

    many_to_many(:teachers, Teacher, join_through: TeacherStudent, on_delete: :delete_all)
    many_to_many(:parents, Parent, join_through: ParentStudent, on_delete: :delete_all)

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

    case Repo.one(query) do
      nil ->
        "unknown"
      date_of_birth ->
      (date_of_birth.months / 12) |> trunc()
    end
  end
end
