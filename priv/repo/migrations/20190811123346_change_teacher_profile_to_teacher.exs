defmodule StudentManager.Repo.Migrations.ChangeTeacherProfileToTeacher do
  use Ecto.Migration

  def change do
    rename table(:teacher_profiles), to: table(:teachers)
  end
end
