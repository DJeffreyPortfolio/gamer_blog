defmodule GamerBlogWeb.PageController do
  use GamerBlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
