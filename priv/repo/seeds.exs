defmodule Karaokium.Repo.Seeds do
  @moduledoc """
  Script for populating the database. You can run it as:
    $ mix run priv/repo/seeds.exs # or mix ecto.seed
  """
  @seeds_dir "priv/repo/seeds"

  def run do
    [
      "accounts.exs"
      # "events.exs",
      # "groups.exs"
    ]
    |> Enum.each(fn file ->
      Code.require_file("#{@seeds_dir}/#{file}")
    end)
  end
end

Karaokium.Repo.Seeds.run()
