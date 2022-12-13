defmodule GamerBlogWeb.ProfileLive.Index do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Accounts
  alias GamerBlog.Profiles
  alias GamerBlog.CMS

  @impl true
  def mount(_params, %{"user_token" => token } = _session, socket) do
    {:ok,
      socket
      |> assign_user(token)
      |> assign(page: 1, per_page: 15)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:profile, Profiles.get_profile!(socket.assigns.current_user.id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:profile, Profiles.get_profile!(socket.assigns.current_user.id))
    |> assign(:following_peoples_posts, show_dashboard_listings(socket.assigns.current_user, socket.assigns.page, socket.assigns.per_page))
  end

  # Need to log out after deleting profile, maybe delete total account?
  #@impl true
  #def handle_event("delete", %{"id" => id}, socket) do
  #  profile = Profiles.get_profile!(id)
  #  {:ok, _} = Profiles.delete_profile(profile)

  #  {:noreply, assign(socket, :profiles, list_profiles())}
  #end

  defp show_dashboard_listings(user, page, per_page) do
    CMS.dashboard_feed(user, page, per_page)
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end
end
