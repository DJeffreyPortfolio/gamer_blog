defmodule GamerBlogWeb.PostLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS
  alias GamerBlog.CMS.Post

  @impl true
  def mount(params, _session, socket) do
    c_id = params["community_id"] |> String.to_integer()

    {:ok,
     socket
     |> stream(:posts, CMS.list_posts(c_id))
     |> assign(:title, assign_title(c_id))
     |> assign(:c_id, c_id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "slug" => slug}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, CMS.get_post!(id, slug))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({GamerBlogWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id, "slug" => slug}, socket) do
    post = CMS.get_post!(id, slug)
    {:ok, _} = CMS.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
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
end
