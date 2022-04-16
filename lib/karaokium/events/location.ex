defmodule Karaokium.Events.Location do
  use Karaokium.Schema

  schema "locations" do
    field :name, :string
    field :address, :string
    field :district, :string
    field :county, :string
    field :locality, :string
    field :postcode, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :address, :district, :county, :locality, :postcode])
    |> validate_required([:name, :address, :district, :county, :locality, :postcode])
  end
end
