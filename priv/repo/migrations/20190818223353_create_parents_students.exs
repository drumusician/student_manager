defmodule StudentManager.Repo.Migrations.CreateParentsStudents do
  use Ecto.Migration

  def change do
    create table(:parents_students) do
      add :parent_id, references(:parents)
      add :student_id, references(:students)

      timestamps()
    end
    create unique_index(:parents_students, [:parent_id, :student_id])
  end
end
