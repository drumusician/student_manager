defmodule StudentManager.AccountsTest do
  use StudentManager.DataCase

  alias StudentManager.Accounts

  describe "users" do
    alias StudentManager.Accounts.User

    @valid_attrs %{type: "student", email: "email@example.com", password: "supersecretpassword", confirm_password: "supersecretpassword"}
    @teacher_attrs %{
      type: "teacher",
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword",
      teacher_profile: %{
        first_name: "John",
        last_name: "The Teacher",
        bio: "A teacher's biography"
      }
    }
    @student_attrs %{
      type: "student",
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword",
      student_profile: %{
        first_name: "Jill",
        last_name: "The Student",
        instrument: "drums"
      }
    }
    @invalid_attrs %{type: "student", email: "bademail@bad", password: "short", confirm_password: "shot" }

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 creates a user with a default role of student" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.roles == ["student"]
    end

    test "create_teacher/1 creates a user with a teacher profile set if the params contain a teacher profile" do
      {:ok, user} = Accounts.create_user(@teacher_attrs)
      assert Enum.member?(user.roles, "teacher")
      refute Enum.member?(user.roles, "student")
      assert user.teacher_profile.first_name == "John"
    end

    test "create_student/1 creates a user with a student profile if the params contain a student profile" do
      {:ok, user} = Accounts.create_user(@student_attrs)
      assert Enum.member?(user.roles, "student")
      refute Enum.member?(user.roles, "teacher")
      assert user.student_profile.first_name == "Jill"
    end
  end
end
