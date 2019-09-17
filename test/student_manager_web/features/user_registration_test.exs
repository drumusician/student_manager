defmodule StudentManagerWeb.UserRegistrationTest do
  use StudentManagerWeb.FeatureCase, async: false

  import Wallaby.Query, only: [css: 2, button: 1, text_field: 1]

  @tag :skip_ci
  test "users can register for a student account", %{session: session} do
    session
    |> visit("/registration/new")
    |> fill_in(text_field("First name"), with: "Sjakie")
    |> fill_in(text_field("Last name"), with: "Sjokola")
    |> fill_in(text_field("Email"), with: "example@email.com")
    |> fill_in(text_field("Password"), with: "secret1234")
    |> fill_in(text_field("Confirm password"), with: "secret1234")
    |> click(button("Register"))
    |> assert_has(css(".notification", text: "Your account has been created successfully"))
  end

  @tag :skip_ci
  test "users can register for a teacher account", %{session: session} do
    session
    |> visit("/registration/new")
    |> click(css("a span", text: "Teacher Registration"))
    |> fill_in(text_field("First name"), with: "Teacher")
    |> fill_in(text_field("Last name"), with: "Man")
    |> fill_in(text_field("Email"), with: "teacher@email.com")
    |> fill_in(text_field("Password"), with: "secret1234")
    |> fill_in(text_field("Confirm password"), with: "secret1234")
    |> click(button("Register"))
    |> assert_has(css(".notification", text: "Your account has been created successfully"))
  end
end
