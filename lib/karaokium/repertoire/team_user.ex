defmodule Karaokium.Repertoire.TeamUser do
  @moduledoc false
  use Karaokium.Schema

  schema "teams_users" do
    field :team_id, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
  end
end
