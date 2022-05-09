defmodule Karaokium.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :emoji, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :performance_id, references(:performances, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:reactions, [:user_id, :performance_id, :emoji])
  end
end
