defmodule KaraokiumWeb.Admin.PerformanceLive.Index do
  use KaraokiumWeb, :live_view

  alias Karaokium.Performances
  alias Karaokium.Performances.Performance

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :performances, list_performances())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Performance")
    |> assign(:performance, Performances.get_performance!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Performance")
    |> assign(:performance, %Performance{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Performances")
    |> assign(:performance, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    performance = Performances.get_performance!(id)
    {:ok, _} = Performances.delete_performance(performance)

    {:noreply, assign(socket, :performances, list_performances())}
  end

  defp list_performances do
    Performances.list_performances()
  end
end
