defmodule Karaokium.Repertoire.ArtistAlbum do
  @moduledoc false
  use Karaokium.Schema

  schema "artists_albums" do
    field :album_id, :string
    field :artist_id, :string

    timestamps()
  end

  @doc false
  def changeset(artist_album, attrs) do
    artist_album
    |> cast(attrs, [:artist_id, :album_id])
    |> validate_required([:artist_id, :album_id])
  end
end
