defmodule Karaokium.Repertoire.ArtistSong do
  @moduledoc false
  use Karaokium.Schema

  schema "artists_songs" do
    field :artist_id, :string
    field :song_id, :string

    timestamps()
  end

  @doc false
  def changeset(artist_song, attrs) do
    artist_song
    |> cast(attrs, [:artist_id, :song_id])
    |> validate_required([:artist_id, :song_id])
  end
end
