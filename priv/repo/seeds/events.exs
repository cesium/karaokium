defmodule Karaokium.Repo.Seeds.Events do
  require Logger

  alias Karaokium.Repo

  alias Karaokium.Events.{Karaoke, Location}

  def run do
    seed_locations()
    seed_karaokes()
  end

  def seed_locations do
    case Repo.all(Location) do
      [] ->
        [
          %{
            name: "York Pub",
            address: "R. Nova de Santa Cruz 23A",
            district: "Braga",
            county: "Braga",
            locality: "Braga",
            postcode: "4710-409"
          },
          %{
            name: " Café-Concerto RUM by Mavy",
            address: "Travessa do Carmo - Edifício Gnration",
            district: "Braga",
            county: "Braga",
            locality: "Braga",
            postcode: "4700-309"
          }
        ]
        |> Enum.each(&insert_location/1)

      _ ->
        Mix.shell().error("Found locations, aborting seeding locations.")
    end
  end

  def seed_karaokes do
    case Repo.all(Karaoke) do
      [] ->
        locations = Repo.all(Location)
        today = Date.utc_today()

        for n <- 1..10 do
          %{
            name: "Karaoke ##{n}",
            start_date: Timex.shift(DateTime.new!(today, ~T[18:00:00]), days: 7 * n),
            end_date: Timex.shift(DateTime.new!(today, ~T[23:00:00]), days: 7 * n),
            location_id: Enum.random(locations).id
          }
        end
        |> Enum.each(&insert_karaoke/1)

      _ ->
        Mix.shell().error("Found karaokes, aborting seeding karaokes.")
    end
  end

  defp insert_karaoke(data) do
    %Karaoke{}
    |> Karaoke.changeset(data)
    |> Repo.insert!()
  end

  defp insert_location(data) do
    %Location{}
    |> Location.changeset(data)
    |> Repo.insert!()
  end
end

Karaokium.Repo.Seeds.Events.run()
