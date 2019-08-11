defmodule StudentManager.Repo.Migrations.RenameStudentProfileToStudent do
  use Ecto.Migration

  def change do
    rename table(:student_profiles), to: table(:students)
  end
end
