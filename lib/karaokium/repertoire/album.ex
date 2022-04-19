defmodule Karaokium.Repertoire.Album do
  use Karaokium.Schema

  alias Karaokium.Media
  alias Karaokium.Repertoire.Artist

  @required_fields ~w(name spotify_id)a
  @optional_fields ~w(release_date total_tracks album_type spotify_id spotify_uri)a

  schema "albums" do
    field :name, :string

    field :release_date, :string
    field :total_tracks, :integer

    field :album_type, Ecto.Enum, values: [:album, :single, :compilation]

    field :spotify_id, :string
    field :spotify_uri, :string

    embeds_many :images, Media.Images
    many_to_many :artists, Artist, join_through: "artists_albums"

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:images)
  end
end
