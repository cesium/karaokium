defmodule Karaokium.Repertoire.Song do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "songs" do
    field :duration_ms, :integer
    field :explicit, :boolean, default: false
    field :href, :string
    field :name, :string
    field :popularity, :integer
    field :preview_url, :string
    field :spotify_id, :string
    field :spotify_uri, :string
    field :spotify_url, :string
    field :track_number, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:spotify_id, :spotify_uri, :name, :duration_ms, :popularity, :preview_url, :spotify_url, :href, :track_number, :explicit])
    |> validate_required([:spotify_id, :spotify_uri, :name, :duration_ms, :popularity, :preview_url, :spotify_url, :href, :track_number, :explicit])
  end
end
