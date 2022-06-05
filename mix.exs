defmodule Karaokium.MixProject do
  use Mix.Project

  @app :karaokium
  @name "Karaokium"
  @version "0.1.0-#{Mix.env()}"
  @description "A Karaoke voting platform"

  def project do
    [
      app: @app,
      name: @name,
      version: @version,
      description: @description,
      git_ref: git_revision_hash(),
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      preferred_cli_env: [check: :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Karaokium.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp releases() do
    [
      {@app,
       [
         include_executables_for: [:unix],
         steps: [:assemble, :tar]
       ]}
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # web
      {:phoenix, "~> 1.6.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.9"},
      {:plug_cowboy, "~> 2.5"},

      # database
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, ">= 0.0.0"},

      # security
      {:argon2_elixir, "~> 3.0"},

      # mailer
      {:swoosh, "~> 1.5"},

      # i18n
      {:gettext, "~> 0.19"},

      # date/time
      {:timex, "~> 3.0"},

      # monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.6"},

      # utilities
      {:csv, "~> 2.4.1"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:nanoid, "~> 2.0.5"},
      {:qrcode_ex, "~> 0.1.0"},

      # testing
      {:floki, ">= 0.30.0", only: :test},

      # development
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:dotenvy, "~> 0.6.0"},

      # tools
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:sobelow, "~> 0.11", only: :dev, runtime: false}
    ]
  end

  # Specifies your project documentation.
  defp docs do
    [
      main: "readme",
      logo: "priv/static/images/logos/logo-ORANGE.svg",
      extras: [{:"README.md", [title: "Overview"]}],
      source_ref: "v#{@version}"
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      check: [
        "clean",
        "deps.unlock --check-unused",
        "compile --all-warnings --warnings-as-errors",
        "format --check-formatted",
        "deps.unlock --check-unused",
        "test --warnings-as-errors",
        "credo --strict --all"
      ],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  defp git_revision_hash do
    case System.cmd("git", ["rev-parse", "HEAD"]) do
      {ref, 0} ->
        ref

      {_, _code} ->
        ["ref:", ref_path] =
          File.read!(".git/HEAD")
          |> String.split()

        File.read!(".git/#{ref_path}")
    end
    |> String.replace("\n", "")
  end
end
