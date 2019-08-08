defmodule StudentManager.Email do
  import Bamboo.Email

  def welcome_email(user) do
    new_email(
      to: user.email,
      from: "support@studman.nl",
      subject: "Welcome to the app.",
      html_body: "<p>Thanks for joining</p>",
      text_body: "Thanks for joining!"
    )
  end
end
