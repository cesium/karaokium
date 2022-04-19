defmodule Karaokium.Repertoire.Song do
  use Karaokium.Schema

  alias Karaokium.Repertoire.Album
  alias Karaokium.Repertoire.Artist

  @required_fields ~w(name spotify_id)a
  @optional_fields ~w(duration_ms track_number explicit href spotify_uri spotify_url preview_url popularity)a

  schema "songs" do
    field :name, :string

    field :duration_ms, :integer
    field :track_number, :integer
    field :explicit, :boolean, default: false

    field :href, :string

    field :spotify_id, :string
    field :spotify_uri, :string
    field :spotify_url, :string
    field :preview_url, :string

    field :popularity, :integer

    belongs_to :album, Album
    many_to_many :artists, Artist, join_through: "artists_songs"

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:album)
    |> cast_assoc(:artists)
  end
end
