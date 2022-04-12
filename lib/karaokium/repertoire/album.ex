defmodule Karaokium.Repertoire.Album do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
