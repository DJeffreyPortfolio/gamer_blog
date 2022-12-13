defmodule GamerBlog.ProfilesTest do
  use GamerBlog.DataCase

  alias GamerBlog.Profiles

  describe "profiles" do
    alias GamerBlog.Profiles.Profile

    import GamerBlog.ProfilesFixtures

    @invalid_attrs %{about: nil, avatar: nil, follower_count: nil, following_count: nil, post_count: nil, username: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Profiles.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{about: "some about", avatar: "some avatar", follower_count: 42, following_count: 42, post_count: 42, username: "some username"}

      assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_attrs)
      assert profile.about == "some about"
      assert profile.avatar == "some avatar"
      assert profile.follower_count == 42
      assert profile.following_count == 42
      assert profile.post_count == 42
      assert profile.username == "some username"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{about: "some updated about", avatar: "some updated avatar", follower_count: 43, following_count: 43, post_count: 43, username: "some updated username"}

      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
      assert profile.about == "some updated about"
      assert profile.avatar == "some updated avatar"
      assert profile.follower_count == 43
      assert profile.following_count == 43
      assert profile.post_count == 43
      assert profile.username == "some updated username"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
      assert profile == Profiles.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end

  describe "likes" do
    alias GamerBlog.Profiles.Like

    import GamerBlog.ProfilesFixtures

    @invalid_attrs %{}

    test "list_likes/0 returns all likes" do
      like = like_fixture()
      assert Profiles.list_likes() == [like]
    end

    test "get_like!/1 returns the like with given id" do
      like = like_fixture()
      assert Profiles.get_like!(like.id) == like
    end

    test "create_like/1 with valid data creates a like" do
      valid_attrs = %{}

      assert {:ok, %Like{} = like} = Profiles.create_like(valid_attrs)
    end

    test "create_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_like(@invalid_attrs)
    end

    test "update_like/2 with valid data updates the like" do
      like = like_fixture()
      update_attrs = %{}

      assert {:ok, %Like{} = like} = Profiles.update_like(like, update_attrs)
    end

    test "update_like/2 with invalid data returns error changeset" do
      like = like_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_like(like, @invalid_attrs)
      assert like == Profiles.get_like!(like.id)
    end

    test "delete_like/1 deletes the like" do
      like = like_fixture()
      assert {:ok, %Like{}} = Profiles.delete_like(like)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_like!(like.id) end
    end

    test "change_like/1 returns a like changeset" do
      like = like_fixture()
      assert %Ecto.Changeset{} = Profiles.change_like(like)
    end
  end
end
