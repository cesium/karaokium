defmodule Karaokium.Events.Karaoke do
  use Karaokium.Schema

  schema "karaokes" do
    field :end_date, :naive_datetime
    field :name, :string
    field :start_date, :naive_datetime
    field :location, :binary_id

    timestamps()
  end

  @doc false
  def changeset(karaoke, attrs) do
    karaoke
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
  end
end
