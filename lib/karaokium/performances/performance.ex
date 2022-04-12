defmodule Karaokium.Performances.Performance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
