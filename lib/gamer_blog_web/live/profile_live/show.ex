defmodule GamerBlogWeb.ProfileLive.Show do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Accounts
  alias GamerBlog.Profiles

  @impl true
  def mount(_params, %{"user_token" => token } = _session, socket) do
    {:ok,
        socket
        |> assign_user(token)
        |> assign(page: 1, per_page: 15),
        temporary_assigns: [posts: []]
      }
  end

  @impl true
  def handle_params(%{"username" => username}, _, socket) do
    {:noreply,
     socket
     |> assign(:profile, Profiles.show_profile!(username))
     #|> assign_posts()
    }
  end

  defp apply_action(socket, :following) do
    following = Profiles.list_following(socket.assigns.user)
    socket |> assign(following: following)
  end

  defp apply_action(socket, :followers) do
    followers = Profiles.list_followers(socket.assigns.user)
    socket |> assign(follower: followers)
  end

  #defp assign_posts(socket) do
  #  socket
  #  |> assign(posts:
  #      CMS.list_profile_posts(
  #      page: socket.assigns.page,
  #      per_page: socket.assigns.per_page,
  #      user_id: socket.assigns.profile.user_id
  #    )
  #  )
  #end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end
end
