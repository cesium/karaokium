defmodule Karaokium.Events.Karaoke do
  use Karaokium.Schema

  alias Karaokium.Events.Location
  alias Karaokium.Groups

  schema "karaokes" do
    field :name, :string
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    belongs_to :location, Location

    many_to_many :teams, Groups.Team, join_through: "teams_karaokes"

    timestamps()
  end

  @doc false
  def changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :start_date, :end_date, :location_id])
    |> validate_required([:name, :start_date, :end_date, :location_id])
  end
end
