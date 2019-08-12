defmodule StudentManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias StudentManager.Accounts.Student
  alias StudentManager.Accounts.Teacher
  alias StudentManager.Repo

  schema "users" do
    field(:roles, {:array, :string}, default: ["student"])
    has_one(:student, Student)
    has_one(:teacher, Teacher)
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def teacher_registration_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Repo.preload(:teacher)
    |> changeset(attrs)
    |> cast_assoc(:teacher)
    |> change(%{roles: ["teacher"]})
  end

  def student_registration_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Repo.preload(:student)
    |> changeset(attrs)
    |> cast_assoc(:student)
    |> change(%{roles: ["student"]})
  end
end
