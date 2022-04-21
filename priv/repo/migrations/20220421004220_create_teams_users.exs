defmodule Karaokium.Repo.Migrations.CreateTeamsUsers do
  use Ecto.Migration

  def change do
    create table(:teams_users, primary_key: false) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
    end

    create index(:teams_users, [:team_id])
    create index(:teams_users, [:user_id])
  end
end
