defmodule GamerBlog.Repo do
  use Ecto.Repo,
    otp_app: :gamer_blog,
    adapter: Ecto.Adapters.Postgres
end
