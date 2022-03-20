defmodule KaraokiumWeb.SongLive.Index do
  use KaraokiumWeb, :live_view

  alias Karaokium.Repertoire
  alias Karaokium.Repertoire.Song

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :songs, list_songs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Song")
    |> assign(:song, Repertoire.get_song!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Song")
    |> assign(:song, %Song{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Songs")
    |> assign(:song, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    song = Repertoire.get_song!(id)
    {:ok, _} = Repertoire.delete_song(song)

    {:noreply, assign(socket, :songs, list_songs())}
  end

  defp list_songs do
    Repertoire.list_songs()
  end
end
