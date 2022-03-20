defmodule Karaokium.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :district, :string
      add :county, :string
      add :locality, :string
      add :address, :string

      timestamps()
    end
  end
end
