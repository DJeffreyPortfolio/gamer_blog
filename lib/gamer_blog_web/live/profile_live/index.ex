defmodule GamerBlogWeb.ProfileLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles
  alias GamerBlog.Profiles.Profile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
  end

  @impl true
  def handle_info({GamerBlogWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, assign(socket, :profiles, profile)}
  end
end
