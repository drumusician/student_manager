defmodule StudentManagerWeb.LayoutView do
  use StudentManagerWeb, :view

  def teacher?(current_user) do
    Enum.member?(current_user.roles, "teacher")
  end
end
