defmodule KaraokiumWeb.Admin.PerformanceLive.FormComponent do
  @moduledoc false
  use KaraokiumWeb, :live_component

  alias Karaokium.Groups
  alias Karaokium.Performances
  alias Karaokium.Repertoire

  @impl true
  def update(%{performance: performance, karaoke_id: karaoke_id} = assigns, socket) do
    changeset = Performances.change_performance(performance)
    songs = Repertoire.list_songs()
    teams = Groups.list_teams()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:songs, songs)
     |> assign(:teams, teams)
     |> assign(:karaoke_id, karaoke_id)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"performance" => performance_params}, socket) do
    changeset =
      socket.assigns.performance
      |> Performances.change_performance(performance_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"performance" => performance_params}, socket) do
    save_performance(socket, socket.assigns.action, performance_params)
  end

  defp save_performance(socket, :edit, performance_params) do
    case Performances.update_performance(socket.assigns.performance, performance_params) do
      {:ok, _performance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Performance updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_performance(socket, :new, performance_params) do
    case Performances.create_performance(
           Map.put(performance_params, "karaoke_id", socket.assigns.karaoke_id)
         ) do
      {:ok, _performance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Performance created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
