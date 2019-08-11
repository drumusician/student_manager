defmodule StudentManager.EmailTest do
  use ExUnit.Case
  alias StudentManager.Accounts.User

  test "welcome email" do
    user = %User{
      email: "student@example.com",
      student: %{
        first_name: "Student",
        last_name: "Johnny"
      }
    }

    email = StudentManager.Email.welcome_email(user)

    assert email.to == user.email
    assert email.from == "support@studman.nl"
    assert email.html_body =~ "<p>Thanks for joining</p>"
    assert email.text_body =~ "Thanks for joining"
  end
end
