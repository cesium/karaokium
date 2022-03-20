defmodule Karaokium.Events.Karaoke do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "karaokes" do
    field :end_date, :date
    field :name, :string
    field :start_date, :date
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
