defmodule StudentManager.Accounts.TeacherStudent do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentManager.Accounts.Teacher
  alias StudentManager.Accounts.Student

  schema "teachers_students" do
    belongs_to(:teacher, Teacher)
    belongs_to(:student, Student)
    field(:current, :boolean, default: true)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:teacher_id, :student_id])
    |> validate_required([:teacher_id, :student_id])
  end
end
