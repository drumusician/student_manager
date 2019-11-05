defmodule StudentManager.Repo.Migrations.CreateLessonSchedule do
  use Ecto.Migration

  def change do
    create table(:lesson_schedules) do
      add(:teacher_id, references(:teachers))
      add(:status, :string)
    end
  end
end
