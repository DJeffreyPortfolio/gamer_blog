defmodule GamerBlog.Likes do
  @moduledoc """
  The Likes context.
  """

  import Ecto.Query, warn: false
  alias GamerBlog.Repo
  alias Ecto.Multi

  def create_like(user, liked) do
    user = Ecto.build_assoc(user, :likes)
    like = Ecto.build_assoc(liked, :likes, user)
    update_total_likes = liked.__struct__ |> where(id: ^liked.id)

    Multi.new()
    |> Multi.insert(:like, like)
    |> Multi.update_all(:update_total_likes, update_total_likes, inc: [total_likes: 1])
    |> Repo.transaction()
  end

  def unlike(user_id, liked) do
    like = get_like(user_id, liked)
    update_total_likes = liked.__struct__ |> where(id: ^liked.id)

    Multi.new()
    |> Multi.delete(:like, like)
    |> Multi.update_all(:update_total_likes, update_total_likes, inc: [total_likes: -1])
    |> Repo.transaction()
  end

  # Returns nil if not found
  defp get_like(user_id, liked) do
    Enum.find(liked.likes, fn l ->
      l.user_id == user_id
    end)
  end
end
