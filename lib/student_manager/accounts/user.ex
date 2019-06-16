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
    |> changeset_role(attrs)
  end
 
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:roles])
    |> validate_inclusion(:roles, ~w(student admin teacher parent))
  end
end
