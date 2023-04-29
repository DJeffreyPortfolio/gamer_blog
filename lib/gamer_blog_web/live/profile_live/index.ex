defmodule GamerBlogWeb.ProfileLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles
  alias GamerBlog.CMS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "5") |> String.to_integer()

    options = %{
      page: page,
      per_page: per_page
    }

    {:noreply,
     socket
     |> assign(options: options)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:profile, Profiles.get_profile!(socket.assigns.current_user.id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:profile, Profiles.get_profile!(socket.assigns.current_user.id))
    |> stream(
      :posts,
      CMS.dashboard_feed(socket.assigns.options, user_id: socket.assigns.current_user.id)
    )
  end

  @impl true
  def handle_info({GamerBlogWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, assign(socket, :profiles, profile)}
  end

  @impl true
  def handle_event("delete", %{"id" => id, "slug" => slug}, socket) do
    post = CMS.get_post!(id, slug)
    {:ok, _} = CMS.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
