defmodule Karaokium.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string
      add :spotify_uri, :string
      add :name, :string
      add :href, :string
      add :spotify_url, :string

      timestamps()
    end
  end
end
