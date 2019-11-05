defmodule StudentManager.Accounts.LessonType do
  use Ecto.Schema
  import Ecto.Changeset

  alias StudentManager.Accounts.{Contract, Teacher}
  alias StudentManager.Repo

  schema "lesson_types" do
    field(:name, :string)
    field(:duration, :integer)
    field(:group_size, :integer)
    field(:frequency, :string)
    has_many(:contracts, Contract)
    belongs_to(:teacher, Teacher)

    timestamps()
  end

  def changeset(lesson_type_or_changeset, attrs) do
    lesson_type_or_changeset
    |> cast(attrs, [:name, :duration, :group_size, :frequency])
    |> validate_required([:name, :duration, :group_size, :frequency])
  end
end
