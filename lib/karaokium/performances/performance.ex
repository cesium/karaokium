defmodule Karaokium.Performances.Performance do
  use Karaokium.Schema

  schema "performances" do
    field :karaoke_id, :binary_id
    field :user_id, :binary_id
    field :song_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [])
    |> validate_required([])
  end
end
