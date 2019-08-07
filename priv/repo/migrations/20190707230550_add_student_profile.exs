defmodule StudentManager.Repo.Migrations.AddStudentProfile do
  use Ecto.Migration

  def change do
    create table(:student_profiles) do
      add :first_name, :string
      add :last_name, :string
      add :instrument, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
