defmodule StudentManager.Accounts.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  alias StudentManager.Accounts.{Student, Teacher}
  alias StudentManager.Repo

  schema "contracts" do
    field(:start_date, :date)
    field(:minutes, :integer)
    belongs_to(:student, Student)
    belongs_to(:teacher, Teacher)

    timestamps()
  end

  def changeset(contract_or_changeset, attrs) do
    contract_or_changeset
    |> cast(attrs, [:start_date, :minutes])
    |> validate_required([:start_date, :minutes])
  end
end
