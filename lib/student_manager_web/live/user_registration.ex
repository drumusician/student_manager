defmodule StudentManagerWeb.UserRegistration do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="tabs is-boxed">
      <ul>
        <li class="<%= if @type == "student", do: "is-active"%>">
          <a>
            <span phx-click="switch-type-student">Student Registration</span>
          </a>
        </li>
        <li class="<%= if @type != "student", do: "is-active"%>">
          <a>
            <span phx-click="switch-type-teacher">Teacher Registration</span>
          </a>
        </li>
      </ul>
    </div>
    <%= if @type == "student" do %>
    <%= Phoenix.View.render StudentManagerWeb.Pow.RegistrationView, "_student_fields.html", changeset: @changeset, f: @f %>
    <% else %>
    <%= Phoenix.View.render StudentManagerWeb.Pow.RegistrationView, "_teacher_fields.html", changeset: @changeset, f: @f %>
    <% end %>
    """
  end

  def mount(session, socket) do
    {:ok, assign(socket, type: "student")}
  end

  def handle_event("switch-type-student", _path, socket) do
    {:noreply, assign(socket, type: "student")}
  end

  def handle_event("switch-type-teacher", _path, socket) do
    {:noreply, assign(socket, type: "teacher")}
  end
end
