defmodule StudentManager.Repo.Migrations.AddIndexesForManyToManyAssociations do
  use Ecto.Migration

  def change do
    create unique_index(:teachers_students, [:teacher_id, :student_id])
  end
end
