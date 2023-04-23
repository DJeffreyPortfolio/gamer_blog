defmodule GamerBlog.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :avatar, :string
      add :about, :text
      add :username, :string
      add :follower_count, :integer
      add :following_count, :integer
      add :post_count, :integer
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:profiles, [:username])
    create index(:profiles, [:user_id])
  end
end
