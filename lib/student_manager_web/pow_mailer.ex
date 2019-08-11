defmodule StudentManagerWeb.PowMailer do
  use Pow.Phoenix.Mailer
  import StudentManager.Mailer

  import Bamboo.Email

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email()
    |> to(user.email)
    |> from("support@studman.nl")
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  def process(email) do
    deliver_now(email)
  end
end
