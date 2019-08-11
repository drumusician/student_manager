# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StudentManager.Repo.insert!(%Studmancase.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias StudentManager.Accounts.{ User, Student, Teacher }

student = StudentManager.Repo.insert!(
  %Student{
    first_name: "Student",
    last_name: "Drums",
    date_of_birth: %Date{ year: 2012, month: 12, day: 12 }
  }
)

StudentManager.Repo.insert!(
  %User{
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
  }
)
