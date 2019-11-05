defmodule StudentManager.Accounts.LessonSchedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias StudentManager.Accounts.Teacher
  alias StudentManager.Repo

  schema "lesson_schedules" do
    belongs_to(:teacher, Teacher)
    field(:status, :string)
    has_many(:lesson_schedule_entries, LessonScheduleEntry)

    timestamps()
  end

  def changeset(lesson_schedule_or_changeset, attrs) do
    lesson_schedule_or_changeset
    |> cast(attrs, [:teacher_id, :status])
    |> validate_required([:teacher_id, :status])
  end
end
