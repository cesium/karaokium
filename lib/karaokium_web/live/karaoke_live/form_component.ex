defmodule KaraokiumWeb.KaraokeLive.FormComponent do
  use KaraokiumWeb, :live_component

  alias Karaokium.Events

  @impl true
  def update(%{karaoke: karaoke} = assigns, socket) do
    changeset = Events.change_karaoke(karaoke)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"karaoke" => karaoke_params}, socket) do
    changeset =
      socket.assigns.karaoke
      |> Events.change_karaoke(karaoke_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"karaoke" => karaoke_params}, socket) do
    save_karaoke(socket, socket.assigns.action, karaoke_params)
  end

  defp save_karaoke(socket, :edit, karaoke_params) do
    case Events.update_karaoke(socket.assigns.karaoke, karaoke_params) do
      {:ok, _karaoke} ->
        {:noreply,
         socket
         |> put_flash(:info, "Karaoke updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_karaoke(socket, :new, karaoke_params) do
    case Events.create_karaoke(karaoke_params) do
      {:ok, _karaoke} ->
        {:noreply,
         socket
         |> put_flash(:info, "Karaoke created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
