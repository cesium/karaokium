defmodule Karaokium.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string
      add :spotify_uri, :string
      add :name, :string
      add :duration_ms, :integer
      add :popularity, :integer
      add :preview_url, :string
      add :spotify_url, :string
      add :href, :string
      add :track_number, :string
      add :explicit, :boolean, default: false, null: false

      timestamps()
    end
  end
end
