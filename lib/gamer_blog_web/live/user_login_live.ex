defmodule GamerBlogWeb.UserLoginLive do
  use GamerBlogWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="row align-items-center justify-items-center px-4 py-5 my-3">
      <div class="col-md-6 offset-md-3">
        <div class="card bg-white rounded">
          <div class="card-body">
            <.header class="text-center">
              Sign in to account
              <:subtitle>
                Don't have an account?
                <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
                  Sign up
                </.link>
                for an account now.
              </:subtitle>
            </.header>

            <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
              <.input field={@form[:email]} type="email" label="Email" required />
              <.input field={@form[:password]} type="password" label="Password" required />

              <:actions>
                <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
                <.link href={~p"/users/reset_password"} class="font-semibold">
                  Forgot your password?
                </.link>
              </:actions>
              <:actions>
                <.button phx-disable-with="Signing in..." class="btn-primary">
                  Sign in <span aria-hidden="true">→</span>
                </.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
