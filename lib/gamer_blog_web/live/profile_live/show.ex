defmodule GamerBlogWeb.ProfileLive.Show do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles
  alias GamerBlog.CMS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"username" => username}, _, socket) do
    {:noreply,
     socket
     |> assign(:profile, Profiles.show_profile!(username))
     |> assign_posts()}
  end

  @impl true
  def handle_info({:update_totals, profile}, socket) do
    {:noreply,
     socket
     |> assign(:profile, Profiles.show_profile!(profile.username))}
  end

  defp assign_posts(socket) do
    socket
    |> stream(:profile_posts, CMS.list_profile_posts(socket.assigns.profile.user_id))
  end
end
