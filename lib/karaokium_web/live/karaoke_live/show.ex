defmodule KaraokiumWeb.KaraokeLive.Show do
  use KaraokiumWeb, :live_view

  alias Karaokium.Events

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    karaoke = Events.get_karaoke!(id, [:performing])

    {:noreply,
     socket
     |> assign(:page_title, karaoke.name)
     |> assign(:karaoke, karaoke)}
  end

  def status(%{karaoke: karaoke} = assigns) when karaoke.status == :waiting do
    ~H"""
    <section>
      <img
        src={Routes.static_path(KaraokiumWeb.Endpoint, "/karaokium/images/illustrations/undraw/season_change.svg")}
        style="max-width: 80%;margin: auto;"
        width="700"
      />
      <header>
        <h1>
          <%= @karaoke.name %> - The Karaoke is not ready yet
        </h1>
      </header>
    </section>
    """
  end

  def status(%{karaoke: karaoke} = assigns) when karaoke.status == :ready do
    ~H"""
    <section>
      <img
        src={Routes.static_path(KaraokiumWeb.Endpoint, "/karaokium/images/illustrations/undraw/happy_music.svg")}
        style="max-width: 80%;margin: auto;"
        width="700"
      />
      <header>
        <h1>
          <%= @karaoke.name %> - The Karaoke is starting soon
        </h1>
      </header>
    </section>
    """
  end
end
