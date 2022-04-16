defmodule Karaokium.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :address, :text
      add :district, :string
      add :county, :string
      add :locality, :string
      add :postcode, :string

      timestamps()
    end
  end
end
