defmodule Karaokium.Groups.Team do
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Events

  schema "teams" do
    field :name, :string

    has_many :users, Accounts.User
    has_many :karaokes, Events.Karaoke

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
