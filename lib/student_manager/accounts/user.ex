defmodule StudentManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema

  alias StudentManager.Accounts.StudentProfile
  alias StudentManager.Accounts.TeacherProfile
  alias StudentManager.Repo

  schema "users" do
    field :roles, {:array, :string}, default: ["student"]
    has_one :student_profile, StudentProfile
    has_one :teacher_profile, TeacherProfile
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Repo.preload([:student_profile, :teacher_profile])
    |> pow_changeset(attrs)
    |> role_changeset(attrs)
  end

  defp role_changeset(user_or_changeset, %{"teacher_profile" => _} = attrs) do
    user_or_changeset
    |> cast_assoc(:teacher_profile)
    |> change(%{roles: ["teacher"]})
  end

  defp role_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> cast_assoc(:student_profile)
    |> change(%{roles: ["student"]})
  end
end
