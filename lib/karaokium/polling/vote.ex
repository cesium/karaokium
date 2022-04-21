defmodule Karaokium.Polling.Vote do
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Performances

  schema "votes" do
    field :pontuation, :integer
    belongs_to :performance, Performances.Performance
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:pontuation, :performance_id, :user_id])
    |> validate_required([:pontuation, :performance_id, :user_id])
  end
end
