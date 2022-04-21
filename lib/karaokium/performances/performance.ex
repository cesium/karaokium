defmodule Karaokium.Performances.Performance do
  use Karaokium.Schema

  alias Karaokium.Events
  alias Karaokium.Groups
  alias Karaokium.Repertoire

  schema "performances" do
    belongs_to :karaoke, Events.Karaoke
    belongs_to :team, Groups.Team
    belongs_to :song, Repertoire.Song

    field :voting?, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [:karaoke_id, :team_id, :song_id, :voting?])
    |> validate_required([:karaoke_id, :team_id, :song_id, :voting?])
  end
end
