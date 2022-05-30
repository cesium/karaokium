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
        name: "Music Contest Bar",
        address: "University Street",
        county: "Braga",
        district: "Braga",
        locality: "Gualtar",
        postcode: "4710-057"
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
        name: "Karaoke ##{System.unique_integer()}",
        end_date: ~N[2022-04-15 02:49:00],
        start_date: ~N[2022-04-15 02:49:00],
        location_id: location_fixture().id
      })
      |> Karaokium.Events.create_karaoke()

    karaoke
  end
end
