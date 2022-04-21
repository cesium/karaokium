defmodule Karaokium.Repo.Migrations.CreateTeamsKaraokes do
  use Ecto.Migration

  def change do
    create table(:teams_karaokes, primary_key: false) do
      add :team_id, :string
      add :karaoke_id, :string
    end
  end
end
