defmodule StudentManager.Accounts.ParentStudent do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentManager.Accounts.Parent
  alias StudentManager.Accounts.Student

  schema "parents_students" do
    belongs_to(:parent, Parent)
    belongs_to(:student, Student)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:parent_id, :student_id])
    |> validate_required([:parent_id, :student_id])
  end
end
