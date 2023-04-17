defmodule GamerBlog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :slug, :string
      add :community_id, :integer
      add :total_likes, :integer
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
