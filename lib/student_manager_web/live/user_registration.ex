defmodule StudentManagerWeb.UserRegistration do
  use Phoenix.LiveView
  alias StudentManager.Accounts
  alias StudentManager.Accounts.User
  alias StudentManager.Email
  alias StudentManager.Mailer

  def render(assigns),
    do: Phoenix.View.render(StudentManagerWeb.Pow.RegistrationView, "new.html", assigns)

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
      |> change_user(socket, params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case create_user(socket, user_params) do
      {:ok, user} ->
        Email.welcome_email(user) |> Mailer.deliver_later()

        {:stop,
         socket
         |> put_flash(
           :info,
           "Your account has been created successfully. An email has been sent to confirm your email. You'll have to follow that link before you can sign in."
         )
         |> redirect(to: "/dashboard")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp create_user(socket, user_params) do
    case socket.assigns.type do
      "student" ->
        Accounts.create_student(user_params)

      "teacher" ->
        Accounts.create_teacher(user_params)
    end
  end

  defp change_user(user, socket, params) do
    case socket.assigns.type do
      "student" ->
        User.student_registration_changeset(user, params)

      "teacher" ->
        User.teacher_registration_changeset(user, params)
    end
  end
end
