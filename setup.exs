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
alias Karaokium.Spotify

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

  song_params = Spotify.get_track(performance["spotify_id"])

    album_params =
      song_params["album"]
      |> swap_field("id", "spotify_id")
      |> swap_field("uri", "spotify_uri")
      |> fix_spotify_url()

    artists_params =
      song_params["artists"]
      |> Enum.map(&swap_field(&1, "id", "spotify_id"))
      |> Enum.map(&swap_field(&1, "uri", "spotify_uri"))
      |> Enum.map(&fix_spotify_url/1)

    song_params =
      song_params
      |> swap_field("id", "spotify_id")
      |> swap_field("uri", "spotify_uri")
      |> fix_spotify_url()
      |> Map.put("album", album_params)
      |> Map.put("artists", artists_params)
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
