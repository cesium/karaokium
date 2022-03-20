defmodule Karaokium.Events.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field :address, :string
    field :county, :string
    field :district, :string
    field :locality, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :district, :county, :locality, :address])
    |> validate_required([:name, :district, :county, :locality, :address])
  end
end
