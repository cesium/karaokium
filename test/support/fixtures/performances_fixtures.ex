defmodule Karaokium.PerformancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Performances` context.
  """

  @doc """
  Generate a performance.
  """
  def performance_fixture(attrs \\ %{}) do
    {:ok, performance} =
      attrs
      |> Enum.into(%{

      })
      |> Karaokium.Performances.create_performance()

    performance
  end
end
