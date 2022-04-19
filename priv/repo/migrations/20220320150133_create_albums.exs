defmodule Karaokium.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      add :release_date, :string
      add :total_tracks, :integer

      add :album_type, :string

      add :spotify_id, :string
      add :spotify_uri, :string

      add :images, {:array, :map}, default: []

      timestamps()
    end
  end
end
