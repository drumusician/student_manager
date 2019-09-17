defmodule StudentManagerWeb.StudentManagementTest do
  use StudentManagerWeb.FeatureCase, async: false
  alias StudentManager.Accounts

  @teacher_attrs %{
    email: "email@teacher.studman",
    password: "secret1234",
    confirm_password: "secret1234",
    teacher: %{
      first_name: "Jan",
      last_name: "De Drumleraar"
    }
  }

  setup do
    {:ok, teacher} = Accounts.create_teacher(@teacher_attrs)

    {:ok, _teacher} =
      PowEmailConfirmation.Ecto.Context.confirm_email(teacher, otp_app: :student_manager)

    :ok
  end

  test "teacher can view a list of students when logged in", %{
    session: session
  } do
    session
    |> login(@teacher_attrs)
    |> visit("/students")
    |> assert_has(css("h1", text: "Students"))
  end

  test "teacher can add a student when logged in", %{
    session: session
  } do
    session
    |> login(@teacher_attrs)
    |> visit("/students/new")
    |> fill_in(text_field("First name"), with: "Pietje")
    |> fill_in(text_field("Last name"), with: "de Drumleerling")
    |> fill_in(text_field("Instrument"), with: "Drums")
    |> fill_in(text_field("Date of birth"), with: "2000-11-11")
    |> click(button("Save"))
    |> assert_text("Pietje")
  end

  test "it is possible to view student details", %{
    session: session
  } do
    session
    |> login(@teacher_attrs)
    |> visit("/students/new")
    |> fill_in(text_field("First name"), with: "Pietje")
    |> fill_in(text_field("Last name"), with: "de Drumleerling")
    |> fill_in(text_field("Instrument"), with: "Drums")
    |> fill_in(text_field("Date of birth"), with: "2000-11-11")
    |> click(button("Save"))
    |> assert_text("Pietje")

    session
    |> click(link("Pietje"))
    |> assert_has(css("h1", text: "Pietje de Drumleerling"))
    |> assert_text("Parents")
  end
end
