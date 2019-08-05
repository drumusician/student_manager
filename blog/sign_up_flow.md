# Real World Phoenix |> Sign Up Flow |> no JS? |> LiveView!

## Sign up as....

# TODO
# - This post should be outlined as:
# - sign up flow using liveview
# - what is the benefit in using it with pow (custom registration overrides without controller callbacks needed)
# - add 2 levels of nested forms profiles + teaching location
# - integration test
# - how to use cast_assoc and when to use cast_assoc instead of put_assoc
# - mention ecto book
# - add dirty unique email check from database constraint
# - next post will be about the CI / CD pipeline and deployment

In the last post we configured our app to be able to handle a sign up of different user roles. In this post we'll explore how we can let these different types of user register for an account.
While you were not watching I have added the Bulma css framework to our app and we'll use that to create a registration page that has 2 tabs. 1 for student registration and one for teacher registration.
Bulma doesn't come with any javascript included, so if we want to have a tab toggle, we'll need to figure out how to switch between them. In our case let's see if Phoenix LiveView can help us out here!

I have played with the idea of only using LiveView for the toggle of these sign-up types, but going with a full LiveView form gives us a couple of benefits. The first being that we can have live form validation even when a user fills in the form. The second benefit has to do with the fact that we are using Pow for our user registration. Since Pow handles the user registration flow, when we want to customise that flow we have to ether use controller callbacks or customise our changeset in a way that becomes a bit tedious. If we use a LiveView form we can bypass the controller flow totally and just use our live component to target the sign-up method needed based on the type of registration.
In this project I had LiveView enabled already. So if you need to add LiveView to your project I'd advise you to check out this awesome guide written by Chris McCord. That'll get you up and running quickly.

With that said, let's look at how we can put together our LiveView form:

We'll create two tabs that will switch between student and teacher signup and use the 'phx-click' binding to switch between these two types. 
```elixir
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
```

I have introduced a @type value that we'll use to switch between the types of registration. It's used to show the selected tab and also to show the fields for student vs teacher registration.

We store the specifics for a student/teacher in a separate table that is associated with the user account. Here we can use the `inputs_for` helper to add associated fields to our form as you can see below:

```elixir
 <%= if @type == "student" do %>
  <%= inputs_for f, :student_profile, fn fp -> %>
  <div class="field">
    <%= label fp, :first_name, class: "label" %>
    <%= text_input fp, :first_name, class: "input" %>
    <%= error_tag fp, :first_name %>
  </div>

  <div class="field">
    <%= label fp, :last_name, class: "label" %>
    <%= text_input fp, :last_name, class: "input" %>
    <%= error_tag fp, :last_name %>
  </div>
  <% end %>
<% else %>
  <%= inputs_for f, :teacher_profile, fn fp -> %>
  <div class="field">
    <%= label fp, :first_name, class: "label" %>
    <%= text_input fp, :first_name, class: "input" %>
    <%= error_tag fp, :first_name %>
  </div>

  <div class="field">
    <%= label fp, :last_name, class: "label" %>
    <%= text_input fp, :last_name, class: "input" %>
    <%= error_tag fp, :last_name %>
  </div>

  <div class="field">
    <%= label fp, :bio, class: "label" %>
    <%= textarea fp, :bio, class: "input" %>
    <%= error_tag fp, :bio %>
  </div>
  <% end %>
<% end %>
```

In our backend we'll need to mount a LiveView component that will handle these interactions. We'll create a file called `lib/student_manager_web/live/user_registration.ex`.

A LiveView module like this needs two things to function correctly. A `render/1` function to render the actual html and a `mount/2` that is used to initialize some state when the component is mounted.

In the `render/1` function I'll render our `.leex` template file with our form.
```elixir
def render(assigns), do: Phoenix.View.render(StudentManagerWeb.Pow.RegistrationView, "new.html", assigns)
```

Just for completeness, here is the full .leex file with our form:
```elixir
<%= f = form_for @changeset, "#", [as: :user, phx_change: :validate, phx_submit: :save] %>
  <%= if @changeset.action do %>
    <div class="alert alert-danger">
      <p>Oops, something went wrong! Please check the errors below.</p>
    </div>
  <% end %>

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
      <%= inputs_for f, :student_profile, fn fp -> %>
      <div class="field">
        <%= label fp, :first_name, class: "label" %>
        <%= text_input fp, :first_name, class: "input" %>
        <%= error_tag fp, :first_name %>
      </div>

      <div class="field">
        <%= label fp, :last_name, class: "label" %>
        <%= text_input fp, :last_name, class: "input" %>
        <%= error_tag fp, :last_name %>
      </div>
      <% end %>
    <% else %>
      <%= inputs_for f, :teacher_profile, fn fp -> %>
      <div class="field">
        <%= label fp, :first_name, class: "label" %>
        <%= text_input fp, :first_name, class: "input" %>
        <%= error_tag fp, :first_name %>
      </div>

      <div class="field">
        <%= label fp, :last_name, class: "label" %>
        <%= text_input fp, :last_name, class: "input" %>
        <%= error_tag fp, :last_name %>
      </div>

      <div class="field">
        <%= label fp, :bio, class: "label" %>
        <%= textarea fp, :bio, class: "input" %>
        <%= error_tag fp, :bio %>
      </div>
      <% end %>
    <% end %>

  <div class="field">
    <%= label f, Pow.Ecto.Schema.user_id_field(@changeset), class: "label" %>
    <div class="control">
      <%= text_input f, Pow.Ecto.Schema.user_id_field(@changeset), class: "input" %>
    </div>
    <%= error_tag f, Pow.Ecto.Schema.user_id_field(@changeset) %>
  </div>

  <div class="field">
    <%= label f, :password, class: "label" %>
    <%= password_input f, :password, value: input_value(f, :password), class: "input" %>
    <%= error_tag f, :password %>
  </div>

  <div class="field">
    <%= label f, :confirm_password, class: "label" %>
    <%= password_input f, :confirm_password, value: input_value(f, :confirm_password), class: "input" %>
    <%= error_tag f, :confirm_password %>
  </div>
  <div>
    <%= submit "Register", phx_disable_with: "Saving...", class: "button is-link" %>
  </div>
</form>
```

So that is pretty straightforward. Now let's create the `mount/2` function and then let's see how we can make the form interactive.

This is what's needed, we are defaulting to the student sign-up below:

```elixir
def mount(_session, socket) do
  {:ok,
    assign(socket, %{
          changeset: Accounts.User.changeset(%User{}, %{}),
          type: "student"
    })}
end
```

The next thing we should add are the event handlers to switch between sign-up types:

```elixir
def handle_event("switch-type-student", _path, socket) do
  {:noreply, assign(socket, type: "student")}
end

def handle_event("switch-type-teacher", _path, socket) do
  {:noreply, assign(socket, type: "teacher")}
end
```
Once we update the `type` value in our assigns, the component will automatically re-render by calling the `render/1` function.

Now it's time ime to create a relationship that will store the student and teacher data. We'll create a Studentprofile and a TeacherProfile. We can define exactly what we want to store there.

These two migrations should do the trick for our database:
```
# add migrations
```elixir
defmodule StudentManager.Repo.Migrations.AddTeacherProfile do
  use Ecto.Migration

  def change do
    create table(:teacher_profiles) do
      add :first_name, :string
      add :last_name, :string
      add :bio, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
```

```elixir
defmodule StudentManager.Repo.Migrations.AddStudentProfile do
  use Ecto.Migration

  def change do
    create table(:student_profiles) do
      add :first_name, :string
      add :last_name, :string
      add :instrument, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
```

In the form page above you had already seen the inputs_for helper that added these fields to our form. So how do we store these associations when we create our user. Fortunately `Ecto` makes this really straightforward! We'll use `cast_assoc` that will use our Teacher and/or StudentProfile changeset method to store the associated struct.

Here is the implementation added to our sign up changesets

```elixir
def teacher_registration_changeset(user_or_changeset, attrs) do
  user_or_changeset
  |> Repo.preload(:teacher_profile)
  |> changeset(attrs)
  |> cast_assoc(:teacher_profile)
  |> change(%{roles: ["teacher"]})
end

def student_registration_changeset(user_or_changeset, attrs) do
  user_or_changeset
  |> Repo.preload(:student_profile)
  |> changeset(attrs)
  |> cast_assoc(:student_profile)
  |> change(%{roles: ["student"]})
end
```

The last part of our puzzle is creating the callbacks for our LiveView Form. The form helper above takes two options which define the callback functions being called in our LiveView component.

```elixir
<%= f = form_for @changeset, "#", [as: :user, phx_change: :validate, phx_submit: :save] %>
```

So `phx_change` and `phx_submit` will call our handlers on any change and submit respectively.

And here are the function definitions in our LiveView component:
```elixir
def handle_event("validate", %{"user" => params}, socket) do
  changeset =
    %User{}
    |> StudentManager.Accounts.User.changeset(params)
    |> Map.put(:action, :insert)

  {:noreply, assign(socket, changeset: changeset)}
end

def handle_event("save", %{"user" => user_params}, socket) do
  case Accounts.create_user(user_params) do
    {:ok, user} ->
      {:stop,
        socket
        |> put_flash(:info, "user created")
        |> redirect(to: "/")}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, changeset: changeset)}
  end
end
```
