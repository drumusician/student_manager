alias StudentManager.Accounts
alias StudentManager.Repo

students = [
  %{
    first_name: "Student",
    last_name: "Drums",
    date_of_birth: %Date{ year: 2012, month: 12, day: 12 }
  },
  %{
    first_name: "Bob",
    last_name: "de Hakker",
    date_of_birth: %Date{ year: 2000, month: 1, day: 4 }
  },
  %{
    first_name: "Dennis",
    last_name: "Chambers",
    date_of_birth: %Date{ year: 1970, month: 7, day: 4 }
  },
  %{
    first_name: "Trommel",
    last_name: "Man",
    date_of_birth: %Date{ year: 2000, month: 1, day: 1 }
  }
]

{:ok, user} = Accounts.create_teacher(
  %{
    email: "info@drumusician.com",
    password: "geheim1234",
    confirm_password: "geheim1234",
    roles: ["teacher"],
    email_confirmed_at: DateTime.now("Etc/UTC"),
    teacher: %{
      first_name: "Tjaco",
      last_name: "Oostdijk",
      bio: "I am a teacher and this is my biography",
    }
  }
)

user = Repo.preload(user, :teacher)

for student <- students do
  Accounts.add_student(user.teacher, student)
end
