defmodule Karaokium.Repertoire.Album do
  use Karaokium.Schema

  schema "albums" do
    field :album_type, :string
    field :name, :string
    field :release_date, :string
    field :spotify_id, :string
    field :spotify_uri, :string
    field :total_tracks, :string

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:spotify_id, :spotify_uri, :name, :total_tracks, :album_type, :release_date])
    |> validate_required([
      :spotify_id,
      :spotify_uri,
      :name,
      :total_tracks,
      :album_type,
      :release_date
    ])
  end
end
