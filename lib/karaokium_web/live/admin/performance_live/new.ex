defmodule KaraokiumWeb.Admin.PerformanceLive.New do
  @moduledoc false
  use KaraokiumWeb, :live_view

  alias Karaokium.Performances.Performance

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"karaoke_id" => karaoke_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:performance, %Performance{})
     |> assign(:page_title, "New Performance")
     |> assign(:karaoke_id, karaoke_id)
     |> assign(:permissions, socket.assigns.current_user.permissions)}
  end
end
