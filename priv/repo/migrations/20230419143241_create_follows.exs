defmodule GamerBlog.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :following_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:follows, [:follower_id])
    create index(:follows, [:following_id])
  end
end
