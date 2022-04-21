defmodule Karaokium.Repo.Migrations.AddPerformingId do
  use Ecto.Migration

  def change do
    alter table(:karaokes) do
      add :performing_id, references(:performances, on_delete: :nothing, type: :binary_id)
      add :status, :string
      add :code, :string
    end
  end
end
