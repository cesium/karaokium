defmodule KaraokiumWeb.SongLive.FormComponent do
  use KaraokiumWeb, :live_component

  alias Karaokium.Repertoire

  @impl true
  def update(%{song: song} = assigns, socket) do
    changeset = Repertoire.change_song(song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset =
      socket.assigns.song
      |> Repertoire.change_song(song_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.action, song_params)
  end

  defp save_song(socket, :edit, song_params) do
    case Repertoire.update_song(socket.assigns.song, song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_song(socket, :new, song_params) do
    case Repertoire.create_song(song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
