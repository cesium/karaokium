defmodule Karaokium.Repertoire.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artists" do
    field :href, :string
    field :name, :string
    field :spotify_id, :string
    field :spotify_uri, :string
    field :spotify_url, :string

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:spotify_id, :spotify_uri, :name, :href, :spotify_url])
    |> validate_required([:spotify_id, :spotify_uri, :name, :href, :spotify_url])
  end
end
