defmodule KaraokiumWeb.Admin.PerformanceLive.Show do
  @moduledoc false
  use KaraokiumWeb, :live_view

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
     |> assign(:performance, Performances.get_performance!(id))}
  end

  defp page_title(:show), do: "Show Performance"
  defp page_title(:edit), do: "Edit Performance"
end
