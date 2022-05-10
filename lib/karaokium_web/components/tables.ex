defmodule KaraokiumWeb.Components.Tables do
  @moduledoc false
  use KaraokiumWeb, :component

  def ranking(assigns) do
    assigns =
      assigns
      |> assign_new(:performances, fn -> [] end)

    ~H"""
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Team</th>
          <th>Song</th>
          <th>Total Votes</th>
          <th>Score</th>
        </tr>
      </thead>
      <tbody id="ranking">
        <%= for {performance, index} <- Enum.with_index(@performances) do %>
          <tr id={"ranking-#{performance.id}"}>
            <td><strong><%= index + 1 %></strong></td>
            <td><strong><%= performance.team.name %></strong></td>
            <td><i><%= performance.song.name %></i></td>
            <td><%= Enum.count(performance.votes) %></td>
            <td><%= performance.score %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
