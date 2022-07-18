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
     |> assign(:karaoke_performance_id, Events.get_karaoke!(karaoke_id).performing_id)
     |> reload()}
  end

  @impl true
  def handle_event("delete", _, socket) do
    socket.assigns.id
    |> Performances.get_performance!()
    |> Performances.delete_performance()

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Performance"
  defp page_title(:edit), do: "Edit Performance"

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(
      :performance,
      Performances.get_performance!(id, [:team, :song, :votes])
    )
  end
end
