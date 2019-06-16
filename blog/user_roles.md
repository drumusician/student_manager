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

Now this gives us a starting point to start testing our `accounts` context.
```elixir

```


