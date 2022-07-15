defmodule KaraokiumWeb.Admin.KaraokeLive.Show do
  @moduledoc false
  use KaraokiumWeb, :live_view

  alias Karaokium.Events
  alias Karaokium.Performances
  alias Karaokium.Polling
  alias KaraokiumWeb.Components.Tables

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Polling.subscribe("votes")
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = _assigns, _, socket) do
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
  def handle_event("reset_pin", _args, socket) do
    socket.assigns.karaoke
    |> Events.reset_pin_karaoke()

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
    socket.assigns.karaoke.id
    |> Events.get_karaoke!()
    |> Events.update_karaoke(%{performing_id: id})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_info({:update, _changes}, socket) do
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

  defp qrcode(url) do
    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#ed7950", background_color: :transparent, width: 340, heigth: 340)
  end
end
