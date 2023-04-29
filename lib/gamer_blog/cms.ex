defmodule GamerBlog.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias GamerBlog.Repo
  alias Ecto.Multi

  alias GamerBlog.CMS.Post
  alias GamerBlog.Accounts.User
  alias GamerBlog.Profiles.{Profile, Follow}

  @doc """
  Returns the list of posts.
  ## Examples
      iex> list_posts()
      [%Post{}, ...]
  """
  def list_posts(options, c_id) do
    Post
    |> where([p], p.community_id == ^c_id)
    |> paginate(options)
    |> order_by([p], desc: p.updated_at)
    |> Repo.all()
    |> Repo.preload(user: [:profile])
  end

  @doc """
  Return posts only for the profile being viewed.
  """
  def list_profile_posts(user_id) do
    Post
    |> where(user_id: ^user_id)
    |> order_by(desc: :id)
    |> Repo.all()
    |> Repo.preload(user: [:profile])
  end

  @doc """
  Gets a single post.
  Raises `Ecto.NoResultsError` if the Post does not exist.
  ## Examples
      iex> get_post!(123)
      %Post{}
      iex> get_post!(456)
      ** (Ecto.NoResultsError)
  """
  def get_post!(id, slug) do
    Post
    |> Repo.get_by!(id: id, slug: slug)
    |> Repo.preload([:likes, user: [:profile]])
  end

  @doc """
  Creates a post.
  ## Examples
      iex> create_post(%{field: value})
      {:ok, %Post{}}
      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_post(%User{} = user, attrs) do
    update_post_count = from(p in Profile, where: p.user_id == ^user.id)
    post_attrs = %Post{} |> Post.changeset(attrs)

    post =
      post_attrs
      |> Ecto.Changeset.put_change(:user_id, user.id)

    Multi.new()
    |> Multi.insert(:post, post)
    |> Multi.update_all(:update_post_count, update_post_count, inc: [post_count: 1])
    |> Repo.transaction()
  end

  @doc """
  Updates a post.
  ## Examples
      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}
      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.
  ## Examples
      iex> delete_post(post)
      {:ok, %Post{}}
      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}
  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.
  ## Examples
      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}
  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def dashboard_feed(options, user_id: user_id) when is_map(options) do
    f_list = following_list(user_id)

    Post
    |> where([p], p.user_id in ^f_list)
    |> or_where([p], p.user_id == ^user_id)
    |> paginate(options)
    |> order_by(desc: :id)
    |> preload(user: [:profile])
    |> Repo.all()
  end

  def following_list(user_id) do
    Follow
    |> where([f], f.follower_id == ^user_id)
    |> select([f], f.following_id)
    |> Repo.all()
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query
end
