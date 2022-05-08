defmodule KaraokiumWeb.Admin.ArtistLive.FormComponent do
  @moduledoc false
  use KaraokiumWeb, :live_component

  alias Karaokium.Repertoire

  @impl true
  def update(%{artist: artist} = assigns, socket) do
    changeset = Repertoire.change_artist(artist)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"artist" => artist_params}, socket) do
    changeset =
      socket.assigns.artist
      |> Repertoire.change_artist(artist_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"artist" => artist_params}, socket) do
    save_artist(socket, socket.assigns.action, artist_params)
  end

  defp save_artist(socket, :edit, artist_params) do
    case Repertoire.update_artist(socket.assigns.artist, artist_params) do
      {:ok, _artist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artist updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_artist(socket, :new, artist_params) do
    case Repertoire.create_artist(artist_params) do
      {:ok, _artist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artist created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
