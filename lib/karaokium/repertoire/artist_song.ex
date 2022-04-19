defmodule Karaokium.Repertoire.ArtistSong do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
