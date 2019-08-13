defmodule StudentManager.Repo.Migrations.AddBirthDateToStudent do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :date_of_birth, :date
    end
  end
end
