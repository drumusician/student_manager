defmodule StudentManager.Repo.Migrations.AddTeacherProfile do
  use Ecto.Migration

  def change do
    create table(:teacher_profiles) do
      add :first_name, :string
      add :last_name, :string
      add :bio, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
