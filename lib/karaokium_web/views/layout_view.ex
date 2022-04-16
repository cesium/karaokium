defmodule KaraokiumWeb.LayoutView do
  use KaraokiumWeb, :view

  alias KaraokiumWeb.Router.Helpers, as: Routes

  defp menu(conn) do
    [
      %{title: "Home", url: Routes.page_path(conn, :index), submenu: []},
      %{
        title: "Events",
        url: "#",
        submenu: [
          %{title: "Karaokes", url: Routes.karaoke_index_path(conn, :index)},
          %{title: "Locations", url: Routes.location_index_path(conn, :index)}
        ]
      },
      %{
        title: "Repertoire",
        url: "#",
        submenu: [
          %{title: "Songs", url: Routes.song_index_path(conn, :index)},
          %{title: "Artists", url: Routes.artist_index_path(conn, :index)},
          %{title: "Albums", url: Routes.album_index_path(conn, :index)}
        ]
      }
    ]
  end

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
