defmodule Karaokium.Events.Karaoke do
  use Karaokium.Schema

  alias Karaokium.Events.Location

  schema "karaokes" do
    field :name, :string
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    belongs_to :location, Location

    timestamps()
  end

  @doc false
  def changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :start_date, :end_date, :location_id])
    |> validate_required([:name, :start_date, :end_date, :location_id])
  end
end
