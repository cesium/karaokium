defmodule KaraokiumWeb.Admin.PerformanceLive.Edit do
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
     |> assign(:performance, Performances.get_performance!(id))
     |> assign(:page_title, "Edit Performance")
     |> assign(:karaoke_id, karaoke_id)}
  end
end
