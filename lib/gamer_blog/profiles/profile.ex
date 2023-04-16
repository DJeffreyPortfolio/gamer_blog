defmodule GamerBlog.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias GamerBlog.Accounts.User

  schema "profiles" do
    field :about, :string
    field :avatar, :string, default: "/images/avatar.png"
    field :post_count, :integer, default: 0
    field :username, :string
    field :who_follow_me_count, :integer, default: 0
    field :who_i_follow_count, :integer, default: 0
    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:about, :username])
    |> validate_required([:about, :username])
    |> validate_username()
    |> unique_constraint(:user_id)
  end

  defp validate_username(username) do
    username
    |> validate_required([:username])
    |> validate_format(:username, ~r/^[a-zA-Z0-9_.-]*$/, message: "Please use letters and numbers without space(only characters allowed _ . -)")
    |> validate_length(:username, min: 3, max: 160)
    |> unsafe_validate_unique(:username, GamerBlog.Repo)
    |> unique_constraint(:username)
  end
end
