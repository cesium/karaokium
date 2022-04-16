defmodule Karaokium.Polling.Vote do
  use Karaokium.Schema

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
