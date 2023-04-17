defmodule GamerBlog.CMSTest do
  use GamerBlog.DataCase

  alias GamerBlog.CMS

  describe "posts" do
    alias GamerBlog.CMS.Post

    import GamerBlog.CMSFixtures

    @invalid_attrs %{community_id: nil, content: nil, slug: nil, title: nil, total_likes: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert CMS.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert CMS.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{community_id: 42, content: "some content", slug: "some slug", title: "some title", total_likes: 42}

      assert {:ok, %Post{} = post} = CMS.create_post(valid_attrs)
      assert post.community_id == 42
      assert post.content == "some content"
      assert post.slug == "some slug"
      assert post.title == "some title"
      assert post.total_likes == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{community_id: 43, content: "some updated content", slug: "some updated slug", title: "some updated title", total_likes: 43}

      assert {:ok, %Post{} = post} = CMS.update_post(post, update_attrs)
      assert post.community_id == 43
      assert post.content == "some updated content"
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
      assert post.total_likes == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_post(post, @invalid_attrs)
      assert post == CMS.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = CMS.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = CMS.change_post(post)
    end
  end
end
