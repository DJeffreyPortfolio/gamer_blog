defmodule GamerBlog.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias GamerBlog.Accounts.User
  alias GamerBlog.Likes.Like

  schema "posts" do
    field :community_id, :integer
    field :content, :string
    field :slug, :string
    field :title, :string
    field :total_likes, :integer, default: 0
    belongs_to :user, User, type: :binary_id
    has_many :likes, Like, foreign_key: :liked_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :slug, :community_id])
    |> build_slug()
    |> validate_required([:title, :content, :slug, :community_id])
  end

  defp build_slug(changeset) do
    if title = get_field(changeset, :title) do
      slug = Slug.slugify(title)
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end
end
