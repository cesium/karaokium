defmodule Karaokium.Repo.Migrations.CreatePerformances do
  use Ecto.Migration

  def change do
    create table(:performances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :karaoke_id, references(:karaokes, on_delete: :nothing, type: :binary_id)
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id)

      add :voting?, :boolean, default: false

      timestamps()
    end

    create index(:performances, [:team_id])
    create index(:performances, [:song_id])
    create index(:performances, [:karaoke_id])

    create unique_index(:performances, [:karaoke_id, :team_id, :song_id])
  end
end
