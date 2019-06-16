defmodule StudentManager.Repo.Migrations.AddRolesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :roles, {:array, :string}, default: ["student"]
    end
  end
end
