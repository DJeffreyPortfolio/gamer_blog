defmodule GamerBlogWeb.LikeComponent do
  use GamerBlogWeb, :live_component

  alias GamerBlog.Likes

  @impl true
  def update(assigns, socket) do
    get_btn_status(socket, assigns)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span phx-target={@myself} phx-click="liked-status" class="w-8 h-8 focus:outline-none ms-4">
      <%= @icon %>
    </span>
    """
  end

  @impl true
  def handle_event("liked-status", _params, socket) do
    current_user = socket.assigns.current_user
    liked = socket.assigns.liked

    if liked?(current_user.id, liked.likes) do
      unlike(socket, current_user.id, liked)
    else
      like(socket, current_user, liked)
    end
  end

  defp like(socket, current_user, liked) do
    case Likes.create_like(current_user, liked) do
      {:ok, liked} ->
        send(self(), {:update_likes, liked})
        {:noreply, socket |> assign(icon: unlike_icon(socket.assigns))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp unlike(socket, current_user_id, liked) do
    case Likes.unlike(current_user_id, liked) do
      {:ok, liked} ->
        send(self(), {:update_likes, liked})
        {:noreply, socket |> assign(icon: like_icon(socket.assigns))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp get_btn_status(socket, assigns) do
    if liked?(assigns.current_user.id, assigns.liked.likes) do
      get_socket_assigns(socket, assigns, unlike_icon(assigns))
    else
      get_socket_assigns(socket, assigns, like_icon(assigns))
    end
  end

  defp get_socket_assigns(socket, assigns, icon) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(icon: icon)}
  end

  defp like_icon(assigns) do
    ~H"""
    <button class="btn btn-outline-primary">
      <%= Bootstrap.Icons.hand_thumbs_up() %>
    </button>
    """
  end

  defp unlike_icon(assigns) do
    ~H"""
    <button class="btn btn-outline-danger">
      <%= Bootstrap.Icons.hand_thumbs_down() %>
    </button>
    """
  end

  # Returns true if id found in list
  defp liked?(user_id, likes) do
    Enum.any?(likes, fn l ->
      l.user_id == user_id
    end)
  end
end
