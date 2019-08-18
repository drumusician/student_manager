defmodule StudentManager.Email do
  use Bamboo.Phoenix, view: StudentManagerWeb.EmailView

  def welcome_email(%{roles: ["teacher"]} = user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to StudMan App")
    |> assign(:user, user)
    |> render("welcome_teacher.html")
  end

  def welcome_email(%{roles: ["student"]} = user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to StudMan App")
    |> assign(:user, user)
    |> render("welcome_student.html")
  end

  defp base_email() do
    new_email()
    |> from("StudMan App<no-reply@drumusician.com>")
    # |> put_layou({StudentManager.LayoutView, :email})
  end
end
