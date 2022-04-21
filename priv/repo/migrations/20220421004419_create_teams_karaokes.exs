defmodule Karaokium.Repo.Migrations.CreateTeamsKaraokes do
  use Ecto.Migration

  def change do
    create table(:teams_karaokes, primary_key: false) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :karaoke_id, references(:karaokes, on_delete: :nothing, type: :binary_id)
    end

    create index(:teams_karaokes, [:team_id])
    create index(:teams_karaokes, [:karaoke_id])
  end
end
