defmodule KaraokiumWeb.Admin.SongLive.Search do
  use KaraokiumWeb, :live_view

  alias Karaokium.Repertoire
  alias Karaokium.Spotify

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :results, [])}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Search Song")}
  end

  @impl true
  def handle_event("suggest", %{"search" => %{"q" => query}}, socket) do
    results = Spotify.search(query) |> Map.get("items")

    {:noreply, assign(socket, :results, results)}
  end

  @impl true
  def handle_event("search", %{"search" => %{"q" => query}}, socket) do
    results = Spotify.search(query) |> Map.get("items")

    {:noreply, assign(socket, :results, results)}
  end

  @impl true
  def handle_event("save", %{"id" => id}, socket) do
    song_params =
      socket.assigns.results
      |> Enum.find(fn entry -> entry["id"] == id end)
      |> IO.inspect()

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

    case Repertoire.create_song(song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> assign(:results, [])}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply,
         socket
         |> put_flash(:error, "Couldn't add song")}
    end
  end

  defp swap_field(map, old_key, new_key) do
    value = Map.get(map, old_key)

    Map.put(map, new_key, value)
    |> Map.drop([old_key])
  end

  defp fix_spotify_url(map) do
    spotify_url = map["external_urls"]["spotify"]

    Map.put(map, "spotify_url", spotify_url)
  end
end
