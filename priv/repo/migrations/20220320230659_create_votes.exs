defmodule Karaokium.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :pontuation, :integer
      add :performance_id, references(:performances, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:votes, [:performance_id])
  end
end
