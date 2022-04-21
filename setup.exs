alias Karaokium.Accounts
alias Karaokium.Accounts.User
alias Karaokium.Events
alias Karaokium.Events.Karaoke
alias Karaokium.Events.Location
alias Karaokium.Groups
alias Karaokium.Groups.Team
alias Karaokium.Performances
alias Karaokium.Performances.Performance
alias Karaokium.Repertoire.Song
alias Karaokium.Repo

location =
  %Location{}
  |> Location.changeset(%{
    name: "York Pub",
    address: "R. Nova de Santa Cruz 23A",
    district: "Braga",
    county: "Braga",
    locality: "Braga",
    postcode: "4710-409"
  })
  |> Repo.insert!()

karaoke =
  %Karaoke{}
  |> Karaoke.changeset(%{
    name: "Karaoke #2",
    start_date: DateTime.new!(Date.utc_today(), ~T[18:00:00]),
    end_date: DateTime.new!(Date.utc_today(), ~T[23:00:00]),
    location_id: location.id
  })
  |> Repo.insert!()

"performances.csv"
|> File.stream!()
|> CSV.decode!(headers: true, strip_fields: true)
|> Enum.each(fn performance ->
  IO.inspect(performance)

  team =
    %Team{}
    |> Team.changeset(%{name: performance["team"]})
    |> Repo.insert!()

  song =
    Karaokium.Repo.get_by(Karaokium.Repertoire.Song, spotify_id: performance["spotify_id"])
    |> IO.inspect()

  %Performance{}
  |> Performance.changeset(%{
    karaoke_id: karaoke.id,
    team_id: team.id,
    song_id: song.id
  })
  |> Repo.insert!()
end)
