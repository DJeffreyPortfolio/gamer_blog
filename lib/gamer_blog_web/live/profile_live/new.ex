defmodule GamerBlogWeb.ProfileLive.New do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Accounts
  alias GamerBlog.Profiles
  alias GamerBlog.Profiles.Profile

  @impl true
  def mount(_params, %{"user_token" => token } = _session, socket) do
      {:ok,
          socket
          |> assign_user(token)
          |> assign(:changeset, Profiles.change_profile(%Profile{}))
      }
  end

  @impl true
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    changeset =
      Profiles.change_profile(%Profile{}, profile_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"profile" => profile_params}, socket) do
      case Profiles.create_profile(socket.assigns.current_user, profile_params) do
        {:ok, _profile} ->
          {:noreply,
           socket
           |> put_flash(:info, "Profile created successfully")
           |> push_redirect(to: Routes.profile_index_path(socket, :index))
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
