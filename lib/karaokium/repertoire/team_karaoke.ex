defmodule Karaokium.Repertoire.TeamKaraoke do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
