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
end
