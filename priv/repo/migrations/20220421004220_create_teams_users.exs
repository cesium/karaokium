defmodule Karaokium.Repo.Migrations.CreateTeamsUsers do
  use Ecto.Migration

  def change do
    create table(:teams_users, primary_key: false) do
      add :team_id, :string
      add :user_id, :string
    end
  end
end
