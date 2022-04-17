defmodule Karaokium.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.

  ```console
  $ bin/karaokium eval "karaokium.Release.migrate"
  ```

  See https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands
  """
  @app :karaokium

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
