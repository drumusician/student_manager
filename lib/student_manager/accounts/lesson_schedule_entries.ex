defmodule StudentManager.Accounts.LessonScheduleEntry do
  use Ecto.Schema
  import Ecto.Changeset

  alias StudentManager.Accounts.{LessonSchedule, Student}
  alias StudentManager.Repo

  schema "lesson_schedule_entries" do
    belongs_to(:lesson_schedule, LessonSchedule)
    belongs_to(:student, Student)
    field(:day_of_the_week, :string)
    field(:start_time, :time)

    timestamps()
  end

  def changeset(lesson_schedule_or_changeset, attrs) do
    lesson_schedule_or_changeset
    |> cast(attrs, [:lesson_schedule_id, :student_id, :day_of_the_week, :start_time])
    |> validate_required([:lesson_schedule_id, :student_id, :day_of_the_week, :start_time])
  end
end
