defmodule GamerBlog.ProfilesTest do
  use GamerBlog.DataCase

  alias GamerBlog.Profiles

  describe "profiles" do
    alias GamerBlog.Profiles.Profile

    import GamerBlog.ProfilesFixtures

    @invalid_attrs %{about: nil, avatar: nil, post_count: nil, username: nil, who_follow_me_count: nil, who_i_follow_count: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Profiles.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{about: "some about", avatar: "some avatar", post_count: 42, username: "some username", who_follow_me_count: 42, who_i_follow_count: 42}

      assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_attrs)
      assert profile.about == "some about"
      assert profile.avatar == "some avatar"
      assert profile.post_count == 42
      assert profile.username == "some username"
      assert profile.who_follow_me_count == 42
      assert profile.who_i_follow_count == 42
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{about: "some updated about", avatar: "some updated avatar", post_count: 43, username: "some updated username", who_follow_me_count: 43, who_i_follow_count: 43}

      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
      assert profile.about == "some updated about"
      assert profile.avatar == "some updated avatar"
      assert profile.post_count == 43
      assert profile.username == "some updated username"
      assert profile.who_follow_me_count == 43
      assert profile.who_i_follow_count == 43
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
end
