defmodule Karaokium.Performances.Performance do
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Events
  alias Karaokium.Repertoire

  schema "performances" do
    belongs_to :karaoke, Events.Karaoke
    belongs_to :user, Accounts.User
    belongs_to :song, Repertoire.Song

    timestamps()
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [:karaoke_id, :user_id, :song_id])
    |> validate_required([:karaoke_id, :user_id, :song_id])
  end
end
