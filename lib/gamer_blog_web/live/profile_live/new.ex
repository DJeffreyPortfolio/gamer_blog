defmodule GamerBlogWeb.ProfileLive.New do
  use GamerBlogWeb, :live_view

  alias GamerBlog.Profiles
  alias GamerBlog.Profiles.Profile

  def mount(_params, _session, socket) do
    changeset = Profiles.change_profile(%Profile{})
    {:ok,
      socket
      |> assign(:profile, %Profile{})
      |> assign_form(changeset)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="row align-items-center justify-items-center px-4 py-5 my-3">
      <div class="col-md-6 offset-md-3">
        <div class="card bg-white rounded">
          <div class="card-body">
            <.header class="text-center">
              Profile
              <:subtitle>Use this form to create your profile.</:subtitle>
            </.header>

            <.simple_form
              for={@form}
              id="profile-form"
              phx-change="validate"
              phx-submit="save"
            >
              <.input field={@form[:username]} type="text" label="Username" />
              <.input field={@form[:about]} type="textarea" label="About" />
              <:actions>
                <.button phx-disable-with="Saving..." class="btn-primary">Save Profile</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    changeset =
      socket.assigns.profile
      |> Profiles.change_profile(profile_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    case Profiles.create_profile!(socket.assigns.current_user, profile_params) do
      {:ok, _profile} ->

        {:noreply,
         socket
         |> put_flash(:info, "Profile created successfully")
         |> push_navigate(to: ~p"/mydashboard")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
