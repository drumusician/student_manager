defmodule StudentManager.Repo.Migrations.CreateLessonType do
  use Ecto.Migration

  def change do
    create table(:lesson_types) do
      add(:name, :string)
      add(:duration, :integer)
      add(:group_size, :integer)
      add(:frequency, :string)
      add(:teacher_id, references(:teachers))

      timestamps()
    end
  end
end
