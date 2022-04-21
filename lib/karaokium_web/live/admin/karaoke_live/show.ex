defmodule KaraokiumWeb.Admin.KaraokeLive.Show do
  use KaraokiumWeb, :live_view

  alias Karaokium.Events
  alias Karaokium.Performances

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = assigns, _, socket) do
    {:noreply,
     socket
     |> assign(:id, id)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> reload()}
  end

  @impl true
  def handle_event("status", %{"status" => status}, socket) do
    socket.assigns.karaoke
    |> Events.update_karaoke(%{status: String.to_existing_atom(status)})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("open_voting", %{"id" => id}, socket) do
    Performances.get_performance!(id)
    |> Performances.update_performance(%{voting?: true})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("close_voting", %{"id" => id}, socket) do
    Performances.get_performance!(id)
    |> Performances.update_performance(%{voting?: false})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("start", %{"id" => id}, socket) do
    socket.assigns.karaoke
    |> Events.update_karaoke(%{performing_id: id})

    {:noreply, reload(socket)}
  end

  defp page_title(:show), do: "Show Karaoke"
  defp page_title(:edit), do: "Edit Karaoke"

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(
      :karaoke,
      Events.get_karaoke!(id, [:location, performances: [:team, :song, :votes]])
    )
  end

  defp score(performance) do
    if performance.votes != [] do
      pontuations = Enum.map(performance.votes, & &1.pontuation)

      (Enum.sum(pontuations) / Enum.count(pontuations))
      |> Decimal.from_float()
      |> Decimal.round(1)
    else
      0
    end
  end

  defp qrcode(url) do
    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#ed7950", background_color: :transparent)
  end
end
