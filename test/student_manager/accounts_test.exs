defmodule StudentManager.AccountsTest do
  use StudentManager.DataCase

  alias StudentManager.Accounts
  alias StudentManager.Accounts.{Student, Teacher, User}
  alias StudentManager.Repo

  require IEx

  describe "users" do
    alias StudentManager.Accounts.User

    @valid_attrs %{
      type: "student",
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword"
    }
    @teacher_attrs %{
      type: "teacher",
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword",
      teacher: %{
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
      student: %{
        first_name: "Jill",
        last_name: "The Student",
        instrument: "drums"
      }
    }
    @invalid_attrs %{
      type: "student",
      email: "bademail@bad",
      password: "short",
      confirm_password: "shot"
    }

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
      assert user.teacher.first_name == "John"
    end

    test "create_student/1 creates a user with a student profile if the params contain a student profile" do
      {:ok, user} = Accounts.create_user(@student_attrs)
      assert Enum.member?(user.roles, "student")
      refute Enum.member?(user.roles, "teacher")
      assert user.student.first_name == "Jill"
    end
  end

  describe "manage students" do
    @teacher_attrs %{
      type: "teacher",
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword",
      teacher: %{
        first_name: "John",
        last_name: "The Teacher",
        bio: "A teacher's biography"
      }
    }

    test "is is possible to add a student associated with a teacher" do
      {:ok, user} = Accounts.create_user(@teacher_attrs)
      teacher = user.teacher

      student_params = %{
        first_name: "Bob",
        last_name: "De Student",
        date_of_birth: %Date{year: 2012, month: 12, day: 12}
      }

      {:ok, teacher} = Accounts.add_student(teacher, student_params)
      new_student = Repo.preload(teacher, :students).students |> List.first()
      assert new_student.first_name == "Bob"
      assert new_student.last_name == "De Student"
      assert (Student.current_teacher(new_student) |> Repo.one()).id == teacher.id
    end

    test "adding a student does not wipe existing students" do
      student =
        StudentManager.Repo.insert!(%Student{
          first_name: "Student",
          last_name: "Drums",
          date_of_birth: %Date{year: 2012, month: 12, day: 12}
        })

      user =
        StudentManager.Repo.insert!(%User{
          email: "info@drumusician.com",
          password: "geheim1234",
          confirm_password: "geheim1234",
          roles: ["teacher"],
          teacher: %Teacher{
            first_name: "Tjaco",
            last_name: "Oostdijk",
            bio: "I am a teacher and this is my birography",
            students: [student]
          }
        })

      teacher = user.teacher

      student_params = %{
        first_name: "Henk",
        last_name: "De Andere Student",
        date_of_birth: %Date{year: 2014, month: 10, day: 10}
      }

      {:ok, teacher} = Accounts.add_student(teacher, student_params)
      new_student = Repo.preload(teacher, :students).students |> List.first()
      first_student = Repo.preload(teacher, :students).students |> List.last()
      assert teacher.students |> length == 2
      assert new_student.first_name == "Henk"
      assert new_student.last_name == "De Andere Student"
      assert first_student.first_name == "Student"
      assert first_student.last_name == "Drums"
    end
  end

  describe "parents" do
    alias StudentManager.Accounts.Parent

    @valid_attrs %{first_name: "Parent", mobile_phone: "0612345678"}
    @student_attrs %{
      first_name: "Student",
      email: "email@student.studman",
      password: "secret1234",
      confirm_password: "secret1234"
    }
    @update_attrs %{first_name: "Updated Parent", mobile_phone: "0687654321"}
    @invalid_attrs %{first_name: nil, mobile_phone: nil}

    def parent_fixture(attrs \\ %{}) do
      {:ok, parent} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_parent()

      parent
    end

    def student_fixture(_attrs \\ %{}) do
      {:ok, student} =
        Student.changeset(%Student{}, @student_attrs)
        |> Repo.insert()

      student
    end

    test "get_parent!/1 returns the parent with given id" do
      parent = parent_fixture()
      assert Accounts.get_parent!(parent.id) == parent
    end

    test "create_parent/1 with valid data creates a parent" do
      assert {:ok, %Parent{} = parent} = Accounts.create_parent(@valid_attrs)
    end

    test "create_parent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_parent(@invalid_attrs)
    end

    test "update_parent/2 with valid data updates the parent" do
      parent = parent_fixture()
      assert {:ok, %Parent{} = parent} = Accounts.update_parent(parent, @update_attrs)
    end

    test "update_parent/2 with invalid data returns error changeset" do
      parent = parent_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_parent(parent, @invalid_attrs)
      assert parent == Accounts.get_parent!(parent.id)
    end

    test "delete_parent/1 deletes the parent" do
      parent = parent_fixture()
      assert {:ok, %Parent{}} = Accounts.delete_parent(parent)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_parent!(parent.id) end
    end

    test "change_parent/1 returns a parent changeset" do
      parent = parent_fixture()
      assert %Ecto.Changeset{} = Accounts.change_parent(parent)
    end
  end
end
