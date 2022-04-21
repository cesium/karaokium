defmodule KaraokiumWeb.KaraokeLive.Show do
  use KaraokiumWeb, :live_view

  alias Karaokium.Events
  alias Karaokium.Performances

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Events.subscribe("karaokes")
      Performances.subscribe("performances")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, reload(socket)}
  end

  @impl true
  def handle_info({:update, _changes}, socket) do
    {:noreply, reload(socket)}
  end

  defp reload(socket) do
    id = socket.assigns.id

    karaoke =
      Events.get_karaoke!(id, performing: [:team, song: [:album, :artists]])
      |> Map.put(:status, :started)

    socket
    |> assign(:page_title, karaoke.name)
    |> assign(:karaoke, karaoke)
  end

  def status(%{karaoke: karaoke} = assigns) when karaoke.status == :waiting do
    ~H"""
    <.status
      img={Routes.static_path(KaraokiumWeb.Endpoint, "/karaokium/images/illustrations/undraw/season_change.svg")}
      text={"#{@karaoke.name} - Waiting to start"}
    />
    """
  end

  def status(%{karaoke: karaoke} = assigns) when karaoke.status == :ready do
    ~H"""
    <.status
      img={Routes.static_path(KaraokiumWeb.Endpoint, "/karaokium/images/illustrations/undraw/happy_music.svg")}
      text={"#{@karaoke.name} - Starting soon"}
    />
    """
  end

  def status(%{img: img, text: text} = assigns) do
    ~H"""
    <section>
      <img src={@img} style="max-width: 80%;margin: auto;" width="700" />
      <header>
        <h1>
          <%= @text %>
        </h1>
      </header>
    </section>
    """
  end
end
