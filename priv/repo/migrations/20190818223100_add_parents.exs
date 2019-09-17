defmodule StudentManager.Repo.Migrations.AddParents do
  use Ecto.Migration

  def change do
    create table(:parents) do
      add :first_name, :string
      add :last_name, :string
      add :mobile_phone, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
