defmodule KaraokiumWeb.AdminSongLive.Show do
  use KaraokiumWeb, :live_view

  alias Karaokium.Repertoire

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:song, Repertoire.get_song!(id))}
  end

  defp page_title(:show), do: "Show Song"
  defp page_title(:edit), do: "Edit Song"
end
