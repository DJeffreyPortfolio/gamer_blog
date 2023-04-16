defmodule GamerBlog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GamerBlogWeb.Telemetry,
      # Start the Ecto repository
      GamerBlog.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GamerBlog.PubSub},
      # Start Finch
      {Finch, name: GamerBlog.Finch},
      # Start the Endpoint (http/https)
      GamerBlogWeb.Endpoint
      # Start a worker by calling: GamerBlog.Worker.start_link(arg)
      # {GamerBlog.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GamerBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GamerBlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
