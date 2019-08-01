defmodule StudentManager.Accounts.TeacherProfile do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentManager.Accounts.User

  schema "teacher_profiles" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:bio, :string)
    belongs_to :user, User

    timestamps()
  end

  def changeset(user_or_changeset, attrs \\ %{}) do
    user_or_changeset
    |> cast(attrs, [:first_name, :last_name, :bio])
  end
end
