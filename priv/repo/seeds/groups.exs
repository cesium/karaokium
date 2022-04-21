defmodule Karaokium.Repo.Seeds.Groups do
  require Logger

  alias Karaokium.Repo

  alias Karaokium.Groups.Team

  @names [
    "Exterminadores",
    "Paysanduba",
    "Rastapés",
    "Sonserinos",
    "Doritos",
    "Farofas",
    "Sexta-feira 13",
    "Pés-rapados",
    "Cuspindo Cobras",
    "Os Gladiadores",
    "Mais ou Menos Velozes",
    "Armas Letais",
    "Foras da Lei",
    "Full Pistolas",
    "Os Renegados",
    "Criadores de Problemas",
    "Memificados",
    "Seu Pior Pesadelo",
    "Um Time que não Tem Nome",
    "Talvez Venceremos",
    "Perder ou Perder",
    "Pisadinhas",
    "Tá Rocheda",
    "Boom Shaka Laka",
    "Iniciantes",
    "Lesmas",
    "Olhos-de-bode",
    "Adrenalizados",
    "Fim de Jogo",
    "Potencializados",
    "Os trapaceiros",
    "Golfinhos",
    "Mercenários",
    "Galos de Briga",
    "Cavaleiros Fantasmas",
    "Olhos de Falcão",
    "Os imbatíveis",
    "Nós tentamos",
    "Só viemos brincar",
    "Segundas Chances",
    "Bando embriagado",
    "Os Famintos",
    "Ex-quarentenados",
    "50 Tons de Idade",
    "Velhos Tempos",
    "Furacões",
    "Infantaria",
    "Invasores",
    "Jaguars",
    "As Sobras"
  ]

  def run do
    seed_teams()
  end

  def seed_teams() do
    case Repo.all(Team) do
      [] ->
        teams =
          @names
          |> Enum.shuffle()
          |> Enum.take(15)

        for name <- teams do
          %{name: name}
        end
        |> Enum.each(&insert_team/1)

      _ ->
        Mix.shell().error("Found teams, aborting seeding teams.")
    end
  end

  defp insert_team(data) do
    %Team{}
    |> Team.changeset(data)
    |> Repo.insert!()
  end
end

Karaokium.Repo.Seeds.Groups.run()
