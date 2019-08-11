defmodule StudentManagerWeb.UserRegistrationTest do
  use StudentManager.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2, button: 1, text_field: 1]

  test "users can register for a student account", %{session: session} do
    session
    |> visit("/")
    |> click(css(".button", text: "Register"))
    |> fill_in(text_field("First name"), with: "Sjakie")
    |> fill_in(text_field("Last name"), with: "Sjokola")
    |> fill_in(text_field("Email"), with: "example@email.com")
    |> fill_in(text_field("Password"), with: "secret1234")
    |> fill_in(text_field("Confirm password"), with: "secret1234")
    |> click(button("Register"))
    |> assert_has(css(".title", text: "StudMan"))
  end

  test "users can register for a teacher account", %{session: session} do
    session
    |> visit("/")
    |> click(css(".button", text: "Register"))
    |> click(css("a span", text: "Teacher Registration"))
    |> assert_has(text_field("Bio"))
    |> fill_in(text_field("First name"), with: "Teacher")
    |> fill_in(text_field("Last name"), with: "Man")
    |> fill_in(text_field("Bio"), with: "This is my biography")
    |> fill_in(text_field("Email"), with: "student@email.com")
    |> fill_in(text_field("Password"), with: "secret1234")
    |> fill_in(text_field("Confirm password"), with: "secret1234")
    |> click(button("Register"))
    |> assert_has(css(".title", text: "StudMan"))
  end
end
