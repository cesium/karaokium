defmodule Karaokium.Repo.Migrations.CreateKaraokes do
  use Ecto.Migration

  def change do
    create table(:karaokes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:karaokes, [:location_id])
  end
end
