defmodule Karaokium.Groups.Team do
  @moduledoc """
  A team is a group of people that sing together in the same performance.
  """
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Events

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
