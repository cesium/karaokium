defmodule Karaokium.Repo.Migrations.CreateArtistsSongs do
  use Ecto.Migration

  def change do
    create table(:artists_songs, primary_key: false) do
      add :artist_id, :string
      add :song_id, :string
    end
  end
end
