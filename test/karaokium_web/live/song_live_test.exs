defmodule KaraokiumWeb.SongLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.RepertoireFixtures

  @create_attrs %{
    duration_ms: 42,
    explicit: true,
    href: "some href",
    name: "some name",
    popularity: 42,
    preview_url: "some preview_url",
    spotify_id: "some spotify_id",
    spotify_uri: "some spotify_uri",
    spotify_url: "some spotify_url",
    track_number: "some track_number"
  }
  @update_attrs %{
    duration_ms: 43,
    explicit: false,
    href: "some updated href",
    name: "some updated name",
    popularity: 43,
    preview_url: "some updated preview_url",
    spotify_id: "some updated spotify_id",
    spotify_uri: "some updated spotify_uri",
    spotify_url: "some updated spotify_url",
    track_number: "some updated track_number"
  }
  @invalid_attrs %{
    duration_ms: nil,
    explicit: false,
    href: nil,
    name: nil,
    popularity: nil,
    preview_url: nil,
    spotify_id: nil,
    spotify_uri: nil,
    spotify_url: nil,
    track_number: nil
  }

  defp create_song(_) do
    song = song_fixture()
    %{song: song}
  end

  describe "Index" do
    setup [:create_song]

    test "lists all songs", %{conn: conn, song: song} do
      {:ok, _index_live, html} = live(conn, Routes.song_index_path(conn, :index))

      assert html =~ "Listing Songs"
      assert html =~ song.href
    end

    test "saves new song", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.song_index_path(conn, :index))

      assert index_live |> element("a", "New Song") |> render_click() =~
               "New Song"

      assert_patch(index_live, Routes.song_index_path(conn, :new))

      assert index_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#song-form", song: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_index_path(conn, :index))

      assert html =~ "Song created successfully"
      assert html =~ "some href"
    end

    test "updates song in listing", %{conn: conn, song: song} do
      {:ok, index_live, _html} = live(conn, Routes.song_index_path(conn, :index))

      assert index_live |> element("#song-#{song.id} a", "Edit") |> render_click() =~
               "Edit Song"

      assert_patch(index_live, Routes.song_index_path(conn, :edit, song))

      assert index_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#song-form", song: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_index_path(conn, :index))

      assert html =~ "Song updated successfully"
      assert html =~ "some updated href"
    end

    test "deletes song in listing", %{conn: conn, song: song} do
      {:ok, index_live, _html} = live(conn, Routes.song_index_path(conn, :index))

      assert index_live |> element("#song-#{song.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#song-#{song.id}")
    end
  end

  describe "Show" do
    setup [:create_song]

    test "displays song", %{conn: conn, song: song} do
      {:ok, _show_live, html} = live(conn, Routes.song_show_path(conn, :show, song))

      assert html =~ "Show Song"
      assert html =~ song.href
    end

    test "updates song within modal", %{conn: conn, song: song} do
      {:ok, show_live, _html} = live(conn, Routes.song_show_path(conn, :show, song))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Song"

      assert_patch(show_live, Routes.song_show_path(conn, :edit, song))

      assert show_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#song-form", song: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_show_path(conn, :show, song))

      assert html =~ "Song updated successfully"
      assert html =~ "some updated href"
    end
  end
end
