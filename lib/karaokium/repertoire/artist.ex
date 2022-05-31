defmodule Karaokium.Repertoire.Artist do
  @moduledoc """
  A Music Artist.
  """
  use Karaokium.Schema

  alias Karaokium.Repertoire.Album
  alias Karaokium.Repertoire.Song

  @required_fields ~w(name spotify_id)a
  @optional_fields ~w(href spotify_uri spotify_url)a

  schema "artists" do
    field :name, :string

    field :href, :string
    field :spotify_id, :string
    field :spotify_uri, :string
    field :spotify_url, :string

    many_to_many :albums, Album, join_through: "artists_albums"
    many_to_many :songs, Song, join_through: "artists_songs"

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
