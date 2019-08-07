defmodule StudentManager.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias StudentManager.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import StudentManagerWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(StudentManager.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(StudentManager.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(StudentManager.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
