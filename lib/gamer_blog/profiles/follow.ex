defmodule GamerBlog.Profiles.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  alias GamerBlog.Accounts.User

  schema "follows" do
    belongs_to :follower, User, type: :binary_id
    belongs_to :following, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
  end
end
