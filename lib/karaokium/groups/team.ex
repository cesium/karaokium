defmodule Karaokium.Groups.Team do
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Events
  alias Karaokium.Repertoire

  schema "teams" do
    field :name, :string

    many_to_many :karaokes, Events.Karaoke, join_through: "teams_karaokes"
    many_to_many :users, Accounts.User, join_through: "teams_users"

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
