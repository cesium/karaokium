defmodule KaraokiumWeb.Admin.KaraokeLive.Show do
  use KaraokiumWeb, :live_view

  alias Karaokium.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:karaoke, Events.get_karaoke!(id, [:location, performances: [:team, :song]]))}
  end

  defp page_title(:show), do: "Show Karaoke"
  defp page_title(:edit), do: "Edit Karaoke"

  defp qrcode(url) do
    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#ed7950", background_color: :transparent)
  end
end
