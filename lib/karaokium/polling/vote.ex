defmodule Karaokium.Polling.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "votes" do
    field :pontuation, :integer
    field :performance_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:pontuation])
    |> validate_required([:pontuation])
  end
end
