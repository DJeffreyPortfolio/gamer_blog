defmodule GamerBlogWeb.PostLive.Show do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"community_id" => community_id, "id" => id, "slug" => slug}, _, socket) do
    {:noreply,
     socket
     |> assign(:post, CMS.get_post!(id, slug))}
  end
end
