defmodule StudentManagerWeb.ParentController do
  use StudentManagerWeb, :controller

  alias StudentManager.Accounts
  alias StudentManager.Accounts.Parent

  def new(conn, _params) do
    changeset = Accounts.change_parent(%Parent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"parent" => parent_params}) do
    case Accounts.create_parent(parent_params) do
      {:ok, parent} ->
        conn
        |> put_flash(:info, "Parent created successfully.")
        |> redirect(to: Routes.parent_path(conn, :show, parent))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    parent = Accounts.get_parent!(id)
    render(conn, "show.html", parent: parent)
  end

  def edit(conn, %{"id" => id}) do
    parent = Accounts.get_parent!(id)
    changeset = Accounts.change_parent(parent)
    render(conn, "edit.html", parent: parent, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parent" => parent_params}) do
    parent = Accounts.get_parent!(id)

    case Accounts.update_parent(parent, parent_params) do
      {:ok, parent} ->
        conn
        |> put_flash(:info, "Parent updated successfully.")
        |> redirect(to: Routes.parent_path(conn, :show, parent))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parent: parent, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parent = Accounts.get_parent!(id)
    {:ok, _parent} = Accounts.delete_parent(parent)

    conn
    |> put_flash(:info, "Parent deleted successfully.")
    |> redirect(to: Routes.parent_path(conn, :index))
  end
end
