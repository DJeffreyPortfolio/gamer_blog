defmodule GamerBlog.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias GamerBlog.Repo

  alias GamerBlog.Accounts.User
  alias GamerBlog.Profiles.{Profile, Follow}

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id) do
    Profile
    |> Repo.get_by!(user_id: id)
  end

  @doc """
  Returns the profile from user.
  """
  def select_profile_id(user_id) do
    Profile
    |> where([p], p.user_id == ^user_id)
    |> select([p], p.id)
    |> Repo.one()
  end

  def show_profile!(username) do
    Profile
    |> Repo.get_by!(username: username)
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile!(%User{} = user, attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  @doc """
  Creates a follow to the given following user, and builds
  user association to be able to preload the user when associations are loaded,
  gets users to update counts, then performs 3 Repo operations,
  creates the follow, updates user followings count, and user followers count,
  we select the user in our updated followers count query, that gets returned
  """
  def create_follow(current_user, profile, attrs \\ %{}) do
    follow_attrs = %Follow{} |> Follow.changeset(attrs)

    follow =
      follow_attrs
      |> Ecto.Changeset.put_change(:follower_id, current_user.id)
      |> Ecto.Changeset.put_change(:following_id, profile.user_id)

    update_following_count = from(p in Profile, where: p.user_id == ^current_user.id)
    update_follower_count = from(p in Profile, where: p.user_id == ^profile.user_id, select: p)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:follow, follow)
    |> Ecto.Multi.update_all(:update_following, update_following_count, inc: [following_count: 1])
    |> Ecto.Multi.update_all(:update_followers, update_follower_count, inc: [follower_count: 1])
    |> Repo.transaction()
  end

  @doc """
  Deletes following association with given user,
  then performs 3 Repo operations, to delete the association,
  update followings count, update and select followers count,
  updated followers count gets returned
  """
  def unfollow(follower_id, following_id) do
    follow = following?(follower_id, following_id)
    update_following_count = from(p in Profile, where: p.user_id == ^following_id)
    update_follower_count = from(p in Profile, where: p.user_id == ^follower_id, select: p)

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:follow, follow)
    |> Ecto.Multi.update_all(:update_following, update_following_count, inc: [following_count: -1])
    |> Ecto.Multi.update_all(:update_followers, update_follower_count, inc: [follower_count: -1])
    |> Repo.transaction()
  end

  @doc """
  Returns nil if not found
  """
  def following?(follower_id, following_id) do
    Follow
    |> Repo.get_by(follower_id: follower_id, following_id: following_id)
  end
end
