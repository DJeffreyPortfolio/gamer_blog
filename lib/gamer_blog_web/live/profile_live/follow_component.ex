defmodule GamerBlogWeb.ProfileLive.FollowComponent do
  use GamerBlogWeb, :live_component

  alias GamerBlog.Profiles

  @impl true
  def update(assigns, socket) do
    get_btn_status(socket, assigns)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <button phx-target={@myself} phx-click="toggle-status" class={@follow_btn_styles}>
      <%= @follow_btn_name %>
    </button>
    """
  end

  @impl true
  def handle_event("toggle-status", _params, socket) do
    current_user = socket.assigns.current_user
    profile = socket.assigns.profile_user

    if Profiles.following?(current_user.id, profile.user_id) do
      unfollow(socket, current_user, profile)
    else
      follow(socket, current_user, profile)
    end
  end

  defp get_btn_status(socket, assigns) do
    if Profiles.following?(assigns.current_user.id, assigns.profile_user.user_id) do
      get_socket_assigns(socket, assigns, "Unfollow", "btn btn-danger")
    else
      get_socket_assigns(socket, assigns, "Follow", "btn btn-primary")
    end
  end

  defp get_socket_assigns(socket, assigns, btn_name, btn_styles) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(follow_btn_name: btn_name)
     |> assign(follow_btn_styles: btn_styles)}
  end

  defp follow(socket, current_user, profile_user) do
    updated_user = Profiles.create_follow(current_user, profile_user)
    # Message sent to the parent liveview to update totals
    send(self(), {__MODULE__, :update_totals, updated_user})

    {:noreply,
     socket
     |> assign(follow_btn_name: "Unfollow")
     |> assign(follow_btn_styles: "btn btn-danger")}
  end

  defp unfollow(socket, current_user, profile_user) do
    updated_profile = Profiles.unfollow(current_user.id, profile_user.user_id)
    # Message sent to the parent liveview to update totals
    send(self(), {__MODULE__, :update_totals, updated_profile})

    {:noreply,
     socket
     |> assign(follow_btn_name: "Follow")
     |> assign(follow_btn_styles: "btn btn-primary")}
  end
end
