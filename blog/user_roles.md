# Real World Phoenix
## User Roles

Welcome back! In the last episode of this series we implemented user authentication.
Now let's see how we can implement user authorization by implementing different user roles into our system.

We used Pow! for our authentication and that library also has a guide for implementing a user roles system.
Let's see how far that get's us and I'd like to actually take it a bit further and implement different
sign up flows for these different user roles.

But as always, we shouldn't get ahead of ourselves and make it too complicated too soon, so we'll first
implement basic user roles. We are going to create these users in a simple manner by just adding a selection
before the registration form that will set this field for the user. I already know I want to be able to define
multple roles in the future so I'll take that into account when creating the field I'm going to use, but we'll
not complicate things too much so 1 role can be selected when signing up.

### Migration and schema

We'll need to store the user roles, so we'll add a migration to store a list of users in the users table:

```elixir
defmodule StudentManager.Repo.Migrations.AddRolesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :roles, {:array, :string}, default: ["student"]
    end
  end
end
```

In this migration I'm taking advantage of the Postgres Array type to store the list of users in the db. It is
of course also possible to store the roles in a different table and at those as an association, but for now
this will do and we can just validate the allowed role values in the Changeset we'll use to store and update
this user role info.

We'll also need to add this new field to our User struct to be able to use it in our application. Here I have also added the validation of the user role values. 

```elixir
defmodule StudentManager.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field(:roles, {:array, :string}, default: ["student"])

    pow_user_fields()

    timestamps()
  end

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Changeset.cast(attrs, [:roles])
    |> Changeset.validate_inclusion(:roles, ~w(student teacher))
  end
end
```

### Testing

In the first blog post I didn;t mention testing at all, but it is a very important part of building a reliable app that is easy to refactor and change with confidence.
Without going into too much details about a proper and full-fledged test setup (I'll cover that in a separate post in the future), I would like to test this
user role addition just to check if the above holds up and we are actually able to add these roles to a user. Now, when creating this app and setting this up in the
first post I briefly mentioned that I was going to add the user under the accounts context. Now, we currently don't have any contexts setup, so let's take advantage
of Phoenix generators to set it up after we've alread created the user. I have confidence that Dan has taken care of the basic testing of the basic user level
fields and changeset, so we are mainly concerned with testing our customisations. Testing the API layer(ie. the context layer) is a very nice
way to test actual behaviour. But can we actually run the generators when we already have part of the contet defined? Let's find out:

```bash
mix phx.gen.context Accounts User users

# outputs:

The following files conflict with new files to be generated:

  * lib/student_manager/accounts/user.ex

See the --web option to namespace similarly named resources

Proceed with interactive overwrite? [Yn] 
* creating lib/student_manager/accounts/user.ex
lib/student_manager/accounts/user.ex already exists, overwrite? [Yn] n
* creating priv/repo/migrations/20190616212819_create_users.exs
* creating lib/student_manager/accounts.ex
* injecting lib/student_manager/accounts.ex
* creating test/student_manager/accounts_test.exs
* injecting test/student_manager/accounts_test.exs

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

Now that is pretty awesome actually. Once we go into `interactive overwrite` it'll ask us if we want to replace any existing files. In our case that's only the `user.ex`
file, and we don't want to override that one! You can also see that it created a new migration, but as we already have that in place we can simply remove that file.

Now this gives us a starting point to start testing our `accounts` context. We'll actually remove some of the boilerplate tests as we don't need them right now and
keep a subset we want to test now. This is what is left of the tests:
```elixir
defmodule StudentManager.AccountsTest do
  use StudentManager.DataCase

  alias StudentManager.Accounts

  describe "users" do
    alias StudentManager.Accounts.User

    @valid_attrs %{email: "email@example.com", password: "supersecretpassword", confirm_password: "supersecretpassword"}
    @invalid_attrs %{email: "bademail@bad", password: "short", confirm_password: "shot" }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

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

    test "create_user/1 validates a correct role" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(Map.put(@valid_attrs, :roles, ["pilot", "teacher"]))
    end
  end
end
```

Now, we could go ahead and add ExMachina (the elixir equivalent of FactoryBot, if you come from ruby...), but for now, let's not :)
So we now have the ability to save user roles attached to a user. Great! I want to do 2 more things, so bear with me for a tad bit longer.

### Custom registration

When visiting this app, it should be easy for potential students as well as teachers to sign up easily and that sign up process should be focussed on their role.
This means a couple of things. First, we should set the role for them when they `sign up as...`, because you don't want them to be entering that themselves. Secondly, 
the information we want to gather is very different when a student signs up compared to a teacher signing up, right? For a teacher I probably want to know what instrument(s) they
teach, if they have existing students (and possibly import them during sign-up), if they have a location where they teach etc etc. This could become very extensive and is definitely
not a sign-up process you want to use for students. For students it should be very simple. What is your name, email and do you have a teacher or are you looking for one
in your neighbourhood. As an example.

So, without implementing all the details of thes sign-up processes. Let's at least create two ways to sign up. The main thing I want to introduce here is the way to use specific
changesets for this purpose. This example should make very clear what I mean here:

```elixir
def teacher_changeset(user_or_changeset, attrs) do
  user_or_changeset
  |> changeset(attrs)
  |> changeset_role(%{roles: ["teacher"]})
end

def student_changeset(user_or_changeset, attrs) do
  user_or_changeset
  |> changeset(attrs)
  |> changeset_role(%{roles: ["student"]})
end
```

And without involving the frontend right away, let's test and create these two api endpoints in our accounts context:

So for the test this should do it:

```elixir
    test "create_teacher/1 creates a user with the teacher role set" do
      {:ok, user} = Accounts.create_teacher(@valid_attrs)
      assert Enum.member?(user.roles, "teacher")
      refute Enum.member?(user.roles, "student")
    end

    test "create_student/1 creates a user with the student role set" do
      {:ok, user} = Accounts.create_student(@valid_attrs)
      assert Enum.member?(user.roles, "student")
      refute Enum.member?(user.roles, "teacher")
    end
```

And to make that pass we'll need to create these two function in the accounts context:
```elixir
  @doc """
  Creates a teacher.

  ## Examples

      iex> create_teacher(%{field: value})
      {:ok, %User{}}

      iex> create_teacher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_teacher(attrs \\ %{}) do
    %User{}
    |> User.teacher_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %User{}}

      iex> create_student(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %User{}
    |> User.student_changeset(attrs)
    |> Repo.insert()
  end
```

And all tests pass! I know what you're thinking. Why duplicate these functions based on only the role! But, yeah I like the explicitness for now and it could possibly diverge
much more content-wise. So I'm gonna leave this as is. The tests are also very nice, concise and fast! Great!

### CanCan or can it!

Ok, you're still here... great! One more thing until I leave you. The whole idea of the introduction of roles in an app like this is that you want to restrict certain users
from doing things they are not supposed to do. So called `authorization`! So in this scenario, most people start to google or hexl for a out-of-the-box solution for this
and they'll find a handfull of them on hex indeed. But let's take a step back, read the excellent pow guides written by Dan, think again, and realize that Plug actually is all we need
to implement this functionality ourselves, no dependencies added! I know there is a trend in Elixir land to get library maintainers going to get more tools in our toolbox, but
the reason sometimes that these tools are not there is simply because we just don't need these dependencies because it is so straightforward to add ourselves. The big benefit in my
opinion being that you fully understand what the code is doing, because you have written it all yourself! A win-win I'd say!

Implementing a Plug is very straightforward and if you want to read up on this, make sure to visit the Plug docs, they're awesome! For now we'll use the suggested implementation
that Dan provides in his guide and leave it at that for now. We'll definitely expand and refine it when we discover places in our app that need some more custom control, but for now I
think I have drained your mental power enough for the day and leave with this Plug:

```elixir
defmodule StudentManagerWeb.Plugs.AuthorizationPlug do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug StudentManagerWeb.Plugs.AuthorizationPlug, [:student, :teacher]

      plug StudentManagerWeb.Plugs.AuthorizationPlug, :teacher

      plug StudentManagerWeb.Plugs.AuthorizationPlug, ~w(student teacher)a
  """
  alias StudentManagerWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, roles) do
    conn
    |> Plug.current_user()
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp has_role?(nil, _roles), do: false
  defp has_role?(user, roles) when is_list(roles), do: Enum.any?(roles, &has_role?(user, &1))
  defp has_role?(user, role) when is_atom(role), do: has_role?(user, Atom.to_string(role))
  defp has_role?(%{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: Routes.page_path(conn, :index))
  end
end
```
Now I believe that should be enough information for now. Next time we'll continue with these sign-up-scopes and see how
we can utilise all of this to easily manage our sign-up process!

Thanks!


