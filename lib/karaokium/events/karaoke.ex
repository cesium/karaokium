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

  def create_changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :status, :start_date, :end_date, :performing_id, :location_id])
    |> validate_required([:name, :status, :start_date, :end_date, :location_id])
    |> maybe_generate_code(generate_code: true)
  end

  def reset_pin_changeset(karaoke) do
    karaoke
    |> cast(%{}, [])
    |> maybe_generate_code(generate_code: true)
  end

  @doc false
  def changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :status, :start_date, :end_date, :performing_id, :location_id])
    |> validate_required([:name, :status, :start_date, :end_date, :location_id])
    |> maybe_generate_code()
  end

  defp maybe_generate_code(changeset, opts \\ []) do
    generate_code? = Keyword.get(opts, :generate_code, false)

    if generate_code? && changeset.valid? do
      changeset
      |> put_change(:code, Nanoid.generate(6, @digits))
    else
      changeset
    end
  end
end
