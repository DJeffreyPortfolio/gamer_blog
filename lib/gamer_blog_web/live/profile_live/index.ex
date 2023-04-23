defmodule GamerBlogWeb.ProfileLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles
  alias GamerBlog.CMS

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page: 1, per_page: 5)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
      CMS.dashboard_feed(
        page: socket.assigns.page,
        per_page: socket.assigns.per_page,
        user_id: socket.assigns.current_user.id
      )
    )
  end

  @impl true
  def handle_info({GamerBlogWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, assign(socket, :profiles, profile)}
  end

  def handle_event("pagination_less", _, socket) do
    socket = update(socket, :page, &max(&1 - 1, 0))
    socket = update(socket, :per_page, &max(&1 - 5, 5))
    {:noreply, socket}
  end

  def handle_event("pagination_more", _, socket) do
    socket = update(socket, :page, &(&1 + 1))
    socket = update(socket, :per_page, &(&1 + 5))
    IO.inspect(socket)
    {:noreply, socket}
  end
end
