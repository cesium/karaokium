defmodule Karaokium.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Events` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        address: "some address",
        county: "some county",
        district: "some district",
        locality: "some locality",
        name: "some name"
      })
      |> Karaokium.Events.create_location()

    location
  end

  @doc """
  Generate a karaoke.
  """
  def karaoke_fixture(attrs \\ %{}) do
    {:ok, karaoke} =
      attrs
      |> Enum.into(%{
        end_date: ~D[2022-03-19],
        name: "some name",
        start_date: ~D[2022-03-19]
      })
      |> Karaokium.Events.create_karaoke()

    karaoke
  end
end
