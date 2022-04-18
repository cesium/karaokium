defmodule KaraokiumWeb.LayoutView do
  use KaraokiumWeb, :view

  alias KaraokiumWeb.Router.Helpers, as: Routes

  defguard is_logged_in(conn) when not is_nil(conn.assigns.current_user)

  def menu(conn) when is_logged_in(conn) do
    base_menu(conn) ++
      Enum.reduce(Enum.sort(conn.assigns.current_user.permissions), [], fn role, acc ->
        case role do
          :admin ->
            acc ++ admin_menu(conn)

          :sysadmin ->
            acc ++ sysadmin_menu(conn)
        end
      end)
  end

  def menu(conn) do
    base_menu(conn)
  end

  defp base_menu(conn) do
    [
      %{title: "Home", url: Routes.page_path(conn, :index), submenu: []}
    ]
  end

  defp admin_menu(conn) do
    [
      %{
        title: "Events",
        url: "#",
        submenu: [
          %{title: "Karaokes", url: Routes.admin_karaoke_index_path(conn, :index)},
          %{title: "Locations", url: Routes.admin_location_index_path(conn, :index)}
        ]
      },
      %{
        title: "Repertoire",
        url: "#",
        submenu: [
          %{title: "Songs", url: Routes.admin_song_index_path(conn, :index)},
          %{title: "Artists", url: Routes.admin_artist_index_path(conn, :index)},
          %{title: "Albums", url: Routes.admin_album_index_path(conn, :index)}
        ]
      }
    ]
  end

  defp sysadmin_menu(conn) do
    [
      %{title: "LiveDashboard", url: Routes.live_dashboard_path(conn, :home), submenu: []}
    ]
  end

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
