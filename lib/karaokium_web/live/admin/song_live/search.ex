defmodule KaraokiumWeb.AdminSongLive.Search do
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

    case Repertoire.create_song(song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> assign(:results, [])}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Couldn't add song")}
    end
  end
end
