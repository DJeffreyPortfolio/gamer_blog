defmodule GamerBlogWeb.PostLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS
  alias GamerBlog.CMS.Post

  @impl true
  def mount(params, _session, socket) do
    c_id = param_to_integer(params["community_id"], 1)

    {:ok,
     socket
     |> assign(:title, assign_title(c_id))
     |> assign(:c_id, c_id)
     |> stream(:posts, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = param_to_integer(params["page"], 1)
    per_page = param_to_integer(params["per_page"], 5)

    options = %{
      page: page,
      per_page: per_page
    }

    posts = CMS.list_posts(options, socket.assigns.c_id)

    socket =
      Enum.reduce(posts, socket, fn post, socket ->
        stream_insert(socket, :posts, post)
      end)

    {:noreply,
     socket
     |> assign(:options, options)
     |> apply_action(socket.assigns.live_action, params)}
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

  defp param_to_integer(nil, default), do: default

  defp param_to_integer(param, default) do
    case Integer.parse(param) do
      {number, _} ->
        number

      :error ->
        default
    end
  end

  defp assign_title(c_id) do
    case c_id do
      1 -> _title = "Apex Legends"
      2 -> _title = "Civilization 6"
      3 -> _title = "Destiny 2"
      4 -> _title = "Fortnite"
      5 -> _title = "Pokemon Blue"
    end
  end
end
