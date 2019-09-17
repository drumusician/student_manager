defmodule StudentManager.Accounts.Parent do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentManager.Accounts.User
  alias StudentManager.Accounts.Student
  alias StudentManager.Accounts.ParentStudent

  schema "parents" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:mobile_phone, :string)
    belongs_to(:user, User)
    many_to_many(:students, Student, join_through: ParentStudent, on_replace: :delete)

    timestamps()
  end

  def changeset(user_or_changeset, attrs \\ %{}) do
    user_or_changeset
    |> cast(attrs, [:first_name, :last_name, :mobile_phone])
    |> validate_required([:first_name, :mobile_phone])
  end
end
