## Real World Phoenix |> Sending and Receiving emails

Sending emails is something probably almost all apps will have to be able to do at some point in time. So how do we go about doing such a thing with
Phoenix and what libraries should we use for this, if any. For a lot of things in Elixir land a library is not something you grab without thinking, but for setting up
email sending from scratch is something pretty tedious so for this task a library is very welcome. Luckily we have a few very good options in Elixir land. As a side note, if
you want to see what options you have for libraries in certain categories, Elixir libhunt is a very nice place to investigate the stats for some similar libraries. It is like the Ruby Toolbox, if you are coming from ruby.

You can check the comparison of some popular email sending libraries here: https://elixir.libhunt.com/categories/705-email
We are not going for the number one in this case(gen_smtp)m as that is a bit too low level OTP. Although that does look nice! The two main ones that work well with Phoenix are
`Swoosh` and `Bamboo`. They are very similar and today I'm going with the one created by Thoughtbot `Bamboo`, mainly because I've used that before. However there is little differnce between the two and both actually 
support most transactional email providers out of the box. For the sake of this tutorial I'll use a free account setup with sendgrid. Sendgrid provides a nice trial period and also has a pretty extensive free number of emails you can send every month.
So more than enough for some simple experiments at least.

Ok, so let's get this show on the road. The main goal I have for this post is to get emails up and running and specifically a welcome email for new signups of my app. The app is a student management app for music teachers, and there is a signup 
form that is built using LiveView that is used to sign up either as a teacher or as a student. The authentication mechanism is built using Pow. 

Let's start by adding `Bamboo` to our mix project.

```elixir
# mix.exs
...
  def deps do
    [{:bamboo, "~> 1.3"}]
  end
...
```

And make sure we pull it in:

```bash
$ mix deps.get
```

We'll need a mailer module for sending the actual emails and one or more email modules for creating emails to be sent. We'll start with the mailer module:

```elixir
defmodule StudentManager.Mailer do
  use Bamboo.Mailer, otp_app: :student_manager
end
```

And here is an example email module for crafting your emails:

```elixir
defmodule StudentManager.Email do
  use Bamboo.Phoenix, view: StudentManagerWeb.EmailView

  def welcome_email(%{roles: ["teacher"]} = user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to StudMan App")
    |> assign(:user, user)
    |> render("welcome_teacher.html")
  end

  def welcome_email(%{roles: ["student"]} = user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to StudMan App")
    |> assign(:user, user)
    |> render("welcome_student.html")
  end

  defp base_email() do
    new_email()
    |> from("support@studman.nl")
  end
end
```

As you can see I already have configured a welcome email to send out to a student and a teacher and if you look closely you'll notice I'm using pattern matching to send out a student or teacher mail based on the role that get's assigned when they sign up. I'm also using Bamboo.Phoenix here in order to take advantage of the template engine included in Phoenix. This really makes it a breeze to create html emails. Normally you would configure this to also send out a plain text version, but for now we'll just create the html version.

One lst thing we need to do is add some configuration for our mailer in `config/config.exs`

```elixir
config :student_manager, Studentmanager.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "my_sendgrid_api_key"

```
Ok, so this is all very straightforward stuff. Just following the guides from `Bamboo` should get you setup and you would be ready to go but... now comes the tricky part. We are using Pow for user registration and that means we are using the pow controllers and routing logic for signup. So where do we add the logic to send out the email when someone registers successfully? Luckily the author of Pow has thought of this scenario and provides hooks that you can plug into the controller logic he has written.
