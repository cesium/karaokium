defmodule Karaokium.Repo.Migrations.CreateArtistsAlbums do
  use Ecto.Migration

  def change do
    create table(:artists_albums, primary_key: false) do
      add :artist_id, :string
      add :album_id, :string
    end
  end
end
