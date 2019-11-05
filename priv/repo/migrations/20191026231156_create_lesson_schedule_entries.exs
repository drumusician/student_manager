defmodule StudentManager.Repo.Migrations.CreateLessonScheduleEntries do
  use Ecto.Migration

  def change do
    create table(:lesson_schedule_entries) do
      add(:lesson_schedule_id, references(:lesson_schedules))
      add(:student_id, references(:students))
      add(:day_of_the_week, :string)
      add(:start_time, :time)
    end
  end
end
