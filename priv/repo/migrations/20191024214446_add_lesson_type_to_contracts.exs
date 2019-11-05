defmodule StudentManager.Repo.Migrations.AddLessonTypeToContracts do
  use Ecto.Migration

  def change do
    alter table(:contracts) do
      add(:lesson_type_id, references(:lesson_types))
    end
  end
end
