defmodule StudentManagerWeb.Live.Parents do
  use Phoenix.LiveView
  alias StudentManager.Accounts
  alias StudentManager.Accounts.Parent

  def render(assigns),
    do: Phoenix.View.render(StudentManagerWeb.ParentView, "index.html", assigns)

  def mount(session, socket) do
    {:ok, student} = Accounts.get_student(session.student_id)
    {:ok, parents} = Accounts.get_parents(student)
    changeset = Accounts.change_parent(%Parent{})

    {:ok,
     assign(socket,
       show_form: false,
       student: student,
       parents: parents,
       changeset: changeset,
       csrf_token: session.csrf_token
     )}
  end

  def handle_event("toggle-form", _path, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end

  def handle_event("validate", %{"parent" => params}, socket) do
    changeset =
      %Parent{}
      |> Parent.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"parent" => parent_params}, socket) do
    student = socket.assigns.student

    case Accounts.add_parent(student, parent_params) do
      {:ok, student} ->
        parents = student.parents

        {:noreply,
         socket
         |> assign(:parents, parents)
         |> assign(:show_form, false)
         |> assign(:changeset, Accounts.change_parent(%Parent{}))
         |> put_flash(:info, "Parent added!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete-parent", id, socket) do
    parent = Accounts.get_parent!(id)

    case Accounts.remove_parent(socket.assigns.student, parent) do
      {:ok, student} ->
        parents = student.parents

        {:noreply,
         socket
         |> assign(:parents, parents)
         |> assign(:show_form, false)
         |> assign(:changeset, Accounts.change_parent(%Parent{}))
         |> put_flash(:info, "Parent added!")}

      {:error, _} ->
        {:noreply,
         socket
         |> assign(:changeset, Accounts.change_parent(%Parent{}))
         |> put_flash(:error, "Oops, that didn't work!")}
    end
  end
end
