defmodule Karaokium.Repo.Migrations.CreatePerformances do
  use Ecto.Migration

  def change do
    create table(:performances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id)
      add :karaoke_id, references(:karaokes, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:performances, [:user_id])
    create index(:performances, [:song_id])
    create index(:performances, [:karaoke_id])
  end
end
