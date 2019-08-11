defmodule StudentManager.Repo.Migrations.CreateTeachersStudentsTable do
  use Ecto.Migration

  def change do
    create table(:teachers_students) do
      add :teacher_id, references(:teachers)
      add :student_id, references(:students)
      add :current, :boolean, default: true

      timestamps()
    end
  end
end
