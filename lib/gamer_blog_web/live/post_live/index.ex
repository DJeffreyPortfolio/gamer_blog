defmodule GamerBlogWeb.PostLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS
  alias GamerBlog.CMS.Post
  alias GamerBlog.Accounts

  @impl true
  def mount(params, %{"user_token" => token } = _session, socket) do
    c_id = params["community_id"]
    c_id = String.to_integer(c_id)
    if connected?(socket), do: GamerBlog.CMS.subscribe()
    {:ok,
      socket
      |> assign_user(token)
      |> assign(:title, assign_title(c_id))
      |> assign(:c_id, c_id)
      |> assign(:posts, list_posts(c_id))
      |> assign(temporary_assigns: [posts: []])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:post, CMS.get_post!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = CMS.get_post!(id)
    c_id = post.community_id
    {:ok, _} = CMS.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts(c_id))}
  end

  defp list_posts(c_id) do
    CMS.list_posts(c_id)
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

  defp assign_title(c_id) do
    case c_id do
      1 -> title = "Apex Legends"
      2 -> title = "Civilization 6"
      3 -> title = "Destiny 2"
      4 -> title = "Fortnite"
      5 -> title = "Warhammer 40k"
    end
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end
end
