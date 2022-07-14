defmodule KaraokiumWeb.Admin.PerformanceLive.Show do
  @moduledoc false
  use KaraokiumWeb, :live_view

  alias Karaokium.Events
  alias Karaokium.Performances

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"karaoke_id" => karaoke_id, "id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:karaoke_id, karaoke_id)
     |> assign(:id, id)
     |> assign(:performancelive, Events.get_karaoke!(karaoke_id).performing_id)
     |> reload()}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Performances.get_performance!(id)
    |> Performances.delete_performance()

    {:noreply, socket}
  end

  @impl true
  def handle_event("open_voting", _, socket) do
    socket.assigns.performance
    |> Performances.update_performance(%{voting?: true})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("close_voting", _, socket) do
    socket.assigns.performance
    |> Performances.update_performance(%{voting?: false})

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("start", %{"id" => id, "karaoke" => karaoke_id}, socket) do
    Events.get_karaoke!(karaoke_id)
    |> Events.update_karaoke(%{performing_id: id})

    {:noreply, reload(socket, :update)}
  end

  defp page_title(:show), do: "Show Performance"
  defp page_title(:edit), do: "Edit Performance"

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(
      :performance,
      Performances.get_performance2!(id, [:team, :song, :votes])
    )
  end

  defp reload(socket, :update) do
    id = socket.assigns.id
    karaoke_id = socket.assigns.karaoke_id

    socket
    |> assign(
      :performance,
      Performances.get_performance2!(id, [:team, :song, :votes])
    )
    |> assign(:performancelive, Events.get_karaoke!(karaoke_id).performing_id)
  end
end
