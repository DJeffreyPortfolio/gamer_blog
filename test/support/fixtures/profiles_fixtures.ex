defmodule GamerBlog.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GamerBlog.Profiles` context.
  """

  @doc """
  Generate a unique profile username.
  """
  def unique_profile_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        about: "some about",
        avatar: "some avatar",
        post_count: 42,
        username: unique_profile_username(),
        who_follow_me_count: 42,
        who_i_follow_count: 42
      })
      |> GamerBlog.Profiles.create_profile()

    profile
  end

  @doc """
  Generate a follow.
  """
  def follow_fixture(attrs \\ %{}) do
    {:ok, follow} =
      attrs
      |> Enum.into(%{

      })
      |> GamerBlog.Profiles.create_follow()

    follow
  end
end
