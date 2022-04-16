defmodule Karaokium.Events.Location do
  use Karaokium.Schema

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
