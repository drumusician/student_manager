defmodule StudentManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema

  schema "users" do
    field(:roles, {:array, :string}, default: ["student"])

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
  end

  def teacher_registration_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> changeset(attrs)
    |> change(%{roles: ["teacher"]})
  end

  def student_registration_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> changeset(attrs)
    |> change(%{roles: ["student"]})
  end
end
