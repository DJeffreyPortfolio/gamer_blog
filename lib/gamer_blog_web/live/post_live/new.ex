defmodule GamerBlogWeb.PostLive.New do
  use GamerBlogWeb, :live_view

  alias GamerBlog.CMS
  alias GamerBlog.CMS.Post
  alias GamerBlog.Accounts

  @impl true
  def mount(_params, %{"user_token" => token } = _session, socket) do
      {:ok,
          socket
          |> assign_user(token)
          |> assign(:changeset, CMS.change_post(%Post{}))
      }
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      CMS.change_post(%Post{}, post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    case CMS.create_post(socket.assigns.current_user, post_params) do
      {:ok, _post} ->
        {:noreply,
          socket
          |> put_flash(:info, "Post created successfully")
          |> push_redirect(to: Routes.post_index_path(socket, :index, 1))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp assign_user(socket, token) do
      assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(token)
      end)
  end

end
