defmodule StudentManager.AccountsTest do
  use StudentManager.DataCase

  alias StudentManager.Accounts

  describe "users" do
    alias StudentManager.Accounts.User

    @valid_attrs %{email: "email@example.com", password: "supersecretpassword", confirm_password: "supersecretpassword"}
    @invalid_attrs %{email: "bademail@bad", password: "short", confirm_password: "shot" }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

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

    test "create_user/1 validates a correct role" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(Map.put(@valid_attrs, :roles, ["pilot", "teacher"]))
    end

    test "create_teacher/1 creates a user with the teacher role set" do
      {:ok, user} = Accounts.create_teacher(@valid_attrs)
      assert Enum.member?(user.roles, "teacher")
      refute Enum.member?(user.roles, "student")
    end

    test "create_student/1 creates a user with the student role set" do
      {:ok, user} = Accounts.create_student(@valid_attrs)
      assert Enum.member?(user.roles, "student")
      refute Enum.member?(user.roles, "teacher")
    end
  end
end
