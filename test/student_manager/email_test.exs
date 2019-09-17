defmodule StudentManager.EmailTest do
  use ExUnit.Case
  alias StudentManager.Accounts.User

  test "welcome email" do
    user = %User{
      email: "student@example.com",
      student: %{
        first_name: "Student",
        last_name: "Johnny"
      },
      email_confirmation_token: "confirmation_token"
    }

    email = StudentManager.Email.welcome_email(user)

    assert email.to == user.email
    assert email.from == "support@studman.nl"

    assert email.html_body =~
             "<p>Hi Student,</p>\n<p>Thanks for signing up for a StudMan account!</p>"
  end
end
