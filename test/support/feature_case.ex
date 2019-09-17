defmodule StudentManagerWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query

      alias StudentManager.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import StudentManagerWeb.Router.Helpers

      def login(session, login_params) do
        session
        |> visit("/session/new")
        |> fill_in(text_field("Email"), with: login_params.email)
        |> fill_in(text_field("Password"), with: login_params.password)
        |> click(button("Login"))
      end
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
