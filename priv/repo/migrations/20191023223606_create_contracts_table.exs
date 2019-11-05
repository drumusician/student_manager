defmodule StudentManager.Repo.Migrations.CreateContractsTable do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add(:start_date, :date)
      add(:minutes, :integer)
      add(:student_id, references(:students))
      add(:teacher_id, references(:teachers))

      timestamps()
    end
  end
end
