defmodule GamerBlog.CMSFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GamerBlog.CMS` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        community_id: 42,
        content: "some content",
        slug: "some slug",
        title: "some title",
        total_likes: 42
      })
      |> GamerBlog.CMS.create_post()

    post
  end
end
