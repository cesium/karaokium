defmodule Karaokium.Events.Karaoke do
  use Karaokium.Schema

  alias Karaokium.Events.Location
  alias Karaokium.Groups
  alias Karaokium.Performances.Performance

  @digits "0123456789"

  schema "karaokes" do
    field :code, :string

    field :name, :string

    field :status, Ecto.Enum, values: [:waiting, :ready, :started], default: :waiting

    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    belongs_to :location, Location
    belongs_to :performing, Performance

    many_to_many :teams, Groups.Team, join_through: "teams_karaokes"
    has_many :performances, Performance

    timestamps()
  end

  @doc false
  def changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :status, :start_date, :end_date, :performing_id, :location_id])
    |> validate_required([:name, :status, :start_date, :end_date, :location_id])
    |> maybe_generate_code()
  end

  defp maybe_generate_code(%Ecto.Changeset{valid?: true, changes: changes} = changeset)
       when not is_map_key(changes, :code) do
    changeset
    |> change(code: Nanoid.generate(6, @digits))
  end

  defp maybe_generate_code(changeset), do: changeset
end
