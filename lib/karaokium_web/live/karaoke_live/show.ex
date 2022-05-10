defmodule KaraokiumWeb.KaraokeLive.Show do
  @moduledoc false
  use KaraokiumWeb, :live_view

  import Karaokium.Performances.Performance, only: [score: 1]

  alias Karaokium.Events
  alias Karaokium.Performances
  alias Karaokium.Polling

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Events.subscribe("karaokes")
      Performances.subscribe("performances")
      Polling.subscribe("reactions")
      Polling.subscribe("votes")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => _id}, _, socket) do
    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("vote", %{"pontuation" => pontuation}, socket) do
    karaoke = Events.get_karaoke!(socket.assigns.id)

    %{pontuation: pontuation}
    |> Map.put(:user_id, socket.assigns.current_user.id)
    |> Map.put(:performance_id, karaoke.performing_id)
    |> Polling.create_vote()

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("react", %{"emoji" => emoji}, socket) do
    karaoke = Events.get_karaoke!(socket.assigns.id)

    %{emoji: emoji}
    |> Map.put(:user_id, socket.assigns.current_user.id)
    |> Map.put(:performance_id, karaoke.performing_id)
    |> Polling.create_reaction()

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("unreact", %{"emoji" => emoji}, socket) do
    karaoke = Events.get_karaoke!(socket.assigns.id)

    Polling.delete_reaction(karaoke.performing_id, socket.assigns.current_user.id, emoji)

    {:noreply, reload(socket)}
  end

  @impl true
  def handle_info({event, _changes}, socket) when event in [:updated, :created, :deleted] do
    {:noreply, reload(socket)}
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

  def status(%{img: _img, text: _text} = assigns) do
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

  defp reaction_count(reactions, emoji) do
    Map.get(reactions, emoji)
  end

  defp has_reacted?(current_user, performance, emoji) do
    users =
      performance.reactions
      |> Enum.filter(fn reaction -> reaction.emoji == emoji end)
      |> Enum.map(& &1.user_id)

    current_user.id in users
  end

  defp has_voted?(current_user, performance) do
    users =
      performance.votes
      |> Enum.map(& &1.user_id)

    current_user.id in users
  end

  defp reload(socket) do
    id = socket.assigns.id

    karaoke =
      Events.get_karaoke!(id, performing: [:team, :votes, :reactions, song: [:album, :artists]])

    reactions = karaoke.performing && Polling.list_reactions(karaoke.performing)

    socket
    |> assign(:page_title, karaoke.name)
    |> assign(:karaoke, karaoke)
    |> assign(:reactions, reactions)
  end
end
