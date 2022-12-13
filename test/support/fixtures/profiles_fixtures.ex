defmodule GamerBlog.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GamerBlog.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        about: "some about",
        avatar: "some avatar",
        follower_count: 42,
        following_count: 42,
        post_count: 42,
        username: "some username"
      })
      |> GamerBlog.Profiles.create_profile()

    profile
  end

  @doc """
  Generate a like.
  """
  def like_fixture(attrs \\ %{}) do
    {:ok, like} =
      attrs
      |> Enum.into(%{

      })
      |> GamerBlog.Profiles.create_like()

    like
  end
end
