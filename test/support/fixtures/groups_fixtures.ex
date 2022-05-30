defmodule Karaokium.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Groups` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Example Team"
      })
      |> Karaokium.Groups.create_team()

    team
  end
end
