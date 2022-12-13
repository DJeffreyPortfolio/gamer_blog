defmodule GamerBlogWeb.PostLive.Show do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS
  alias GamerBlog.Accounts

  @impl true
  def mount(_params, %{"user_token" => token } = _session, socket) do
    {:ok,
      socket
      |> assign_user(token)
    }
  end

  @impl true
  def handle_params(%{"community_id" => community_id, "id" => id, "slug" => slug}, _, socket) do
    {:noreply,
     socket
     |> assign(:post, CMS.get_post!(id, slug))
    }
  end

  @impl true
  def handle_info({:update_likes, likes}, socket) do
    {:noreply,
      socket
      |> assign(:post, CMS.get_post!(socket.assigns.id, socket.assigns.slug))
    }
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end
end
