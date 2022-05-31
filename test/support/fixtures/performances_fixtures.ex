defmodule Karaokium.PerformancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Performances` context.
  """
  import Karaokium.RepertoireFixtures
  import Karaokium.EventsFixtures
  import Karaokium.GroupsFixtures

  @doc """
  Generate a performance.
  """
  def performance_fixture(attrs \\ %{}) do
    {:ok, performance} =
      attrs
      |> Enum.into(%{
        song_id: song_fixture().id,
        karaoke_id: karaoke_fixture().id,
        team_id: team_fixture().id
      })
      |> Karaokium.Performances.create_performance()

    performance
  end
end
