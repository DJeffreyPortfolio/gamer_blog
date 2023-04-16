defmodule GamerBlogWeb.ProfileLive.Show do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"username" => username}, _, socket) do
    {:noreply,
     socket
     |> assign(:profile, Profiles.show_profile!(username))}
  end

end
