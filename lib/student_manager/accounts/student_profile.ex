defmodule StudentManager.Accounts.StudentProfile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Accounts.User

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:instrument, :string)
    belongs_to :user, User

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:first_name, :last_name, :instrument])
  end
end
