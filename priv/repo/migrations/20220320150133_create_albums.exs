defmodule Karaokium.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string
      add :spotify_uri, :string
      add :name, :string
      add :total_tracks, :string
      add :album_type, :string
      add :release_date, :string

      timestamps()
    end
  end
end
