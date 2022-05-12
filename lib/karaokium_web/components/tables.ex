defmodule KaraokiumWeb.Components.Tables do
  @moduledoc false
  use KaraokiumWeb, :component

  @ranking %{
    colors: %{1 => "#ffd700", 2 => "#c0c0c0", 3 => "#cd7f32"}
  }

  def ranking(assigns) do
    assigns =
      assigns
      |> assign_new(:performances, fn -> [] end)
      |> assign_new(:ranking, fn -> @ranking end)

    ~H"""
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Performance</th>
          <th>Score</th>
        </tr>
      </thead>
      <tbody id="ranking">
        <%= for {performance, index} <- Enum.with_index(@performances) do %>
          <tr id={"ranking-#{performance.id}"} style={"background-color: #{@ranking.colors[index + 1]};"}>
            <td><strong><%= index + 1 %></strong></td>
            <td>
              <strong><%= performance.team.name %></strong>
              <br />
              <i><%= performance.song.name %></i>
            </td>
            <td><%= performance.score %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
