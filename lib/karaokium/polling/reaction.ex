defmodule Karaokium.Polling.Reaction do
  @moduledoc """
  A user reaction to a performance.
  """
  use Karaokium.Schema

  alias Karaokium.Accounts
  alias Karaokium.Performances

  @emojis [:"👍", :"❤️", :"🎉", :"⭐️"]

  schema "reactions" do
    field :emoji, Ecto.Enum, values: @emojis
    belongs_to :performance, Performances.Performance
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(reaction, attrs) do
    reaction
    |> cast(attrs, [:emoji, :performance_id, :user_id])
    |> validate_required([:emoji, :performance_id, :user_id])
  end
end
