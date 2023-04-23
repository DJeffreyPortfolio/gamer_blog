# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GamerBlog.Repo.insert!(%GamerBlog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query, warn: false
alias GamerBlog.Repo

alias GamerBlog.Accounts
alias GamerBlog.Profiles
alias GamerBlog.CMS
alias GamerBlog.Likes
alias Faker.{Superhero, Lorem}

# Creating 40 Acounts
for n <- 1..5 do
  Accounts.register_user(%{email: "test#{n + 1}@test.com", password: "password1234"})
end

# Gets all users
users = Repo.all(Accounts.User)

# Create profiles for each user
for user <- users do
  generate_username =
    Faker.Superhero.descriptor()
    |> String.replace([".", "'", " "], "", global: true)

  attrs = %{
    "username" => "#{Superhero.prefix()}_#{generate_username}",
    "about" => Lorem.paragraph(5)
  }

  %Profiles.Profile{}
  |> Profiles.Profile.changeset(attrs)
  |> Ecto.Changeset.put_change(:user_id, user.id)
  |> Repo.insert!()
end

# Gets random users to be followers
rand_followers = fn user ->
  limit_number = Enum.random(1..2)

  Profiles.Profile
  |> where([p], p.user_id != ^user.id)
  |> limit(^limit_number)
  |> Repo.all()
end

# Adds random follows to all users
for user <- users do
  for follower <- rand_followers.(user) do
    Profiles.create_follow(user, follower)
  end
end

# Creates posts for all users
for user <- users do
  post_range = Enum.random(10..30)

  for _ <- 1..post_range do
    rand_community = Enum.random(1..5)

    attrs = %{
      "community_id" => rand_community,
      "title" => Faker.Lorem.sentence(1),
      "content" => Faker.Lorem.paragraph(1..3)
    }

    CMS.create_post(user, attrs)
  end
end

# Gets all posts
posts = CMS.Post |> Repo.all()

# Gets random users to given number range to be likers
rand_users = fn range ->
  limit_n = Enum.random(range)

  Accounts.User
  |> limit(^limit_n)
  |> Repo.all()
end

# Adds likes to all posts
for post <- posts do
  for user <- rand_users.(1..3) do
    Likes.create_like(user, post)
  end
end
