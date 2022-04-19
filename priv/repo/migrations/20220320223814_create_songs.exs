defmodule Karaokium.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string

      add :duration_ms, :integer
      add :track_number, :integer
      add :explicit, :boolean, default: false, null: false

      add :href, :string

      add :spotify_id, :string
      add :spotify_uri, :string
      add :spotify_url, :string
      add :preview_url, :string

      add :popularity, :integer

      add :album_id,
          references(:albums, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:songs, [:spotify_id])
  end
end
