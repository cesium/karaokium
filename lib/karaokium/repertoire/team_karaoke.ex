defmodule Karaokium.Repertoire.TeamKaraoke do
  @moduledoc false
  use Karaokium.Schema

  schema "teams_karaokes" do
    field :karaoke_id, :string
    field :team_id, :string

    timestamps()
  end

  @doc false
  def changeset(team_karaoke, attrs) do
    team_karaoke
    |> cast(attrs, [:team_id, :karaoke_id])
    |> validate_required([:team_id, :karaoke_id])
  end
end
