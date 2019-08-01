defmodule StudentManagerWeb.UserRegistration do
  use Phoenix.LiveView
  alias StudentManager.Accounts
  alias StudentManager.Accounts.User

  def render(assigns), do: Phoenix.View.render(StudentManagerWeb.Pow.RegistrationView, "new.html", assigns)

  def mount(_session, socket) do
    {:ok,
     assign(socket, %{
           changeset: Accounts.User.changeset(%User{}, %{}),
           type: "student"
     })}
  end

  def handle_event("switch-type-student", _path, socket) do
    {:noreply, assign(socket, type: "student")}
  end

  def handle_event("switch-type-teacher", _path, socket) do
    {:noreply, assign(socket, type: "teacher")}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> StudentManager.Accounts.User.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:stop,
         socket
         |> put_flash(:info, "user created")
         |> redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
