defmodule StudentManagerWeb.StudentView do
  use StudentManagerWeb, :view

  alias StudentManager.Accounts.Student
  def age(student) do
    Student.age(student)
  end
end
