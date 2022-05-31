defmodule Karaokium.PollingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Polling` context.
  """

  import Karaokium.AccountsFixtures
  import Karaokium.PerformancesFixtures

  @doc """
  Generate a vote.
  """
  def vote_fixture(attrs \\ %{}) do
    {:ok, vote} =
      attrs
      |> Enum.into(%{
        pontuation: 10,
        performance_id: performance_fixture().id,
        user_id: user_fixture().id
      })
      |> Karaokium.Polling.create_vote()

    vote
  end

  @doc """
  Generate a reaction.
  """
  def reaction_fixture(attrs \\ %{}) do
    {:ok, reaction} =
      attrs
      |> Enum.into(%{
        emoji: :"👍",
        performance_id: performance_fixture().id,
        user_id: user_fixture().id
      })
      |> Karaokium.Polling.create_reaction()

    reaction
  end
end
