defmodule KaraokiumWeb.Admin.KaraokeLive.Index do
  use KaraokiumWeb, :live_view

  alias Karaokium.Events
  alias Karaokium.Events.Karaoke

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :karaokes, list_karaokes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Karaoke")
    |> assign(:karaoke, Events.get_karaoke!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Karaoke")
    |> assign(:karaoke, %Karaoke{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Karaokes")
    |> assign(:karaoke, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    karaoke = Events.get_karaoke!(id)
    {:ok, _} = Events.delete_karaoke(karaoke)

    {:noreply, assign(socket, :karaokes, list_karaokes())}
  end

  defp list_karaokes do
    Events.list_karaokes(preloads: :location)
    |> IO.inspect()
  end
end
