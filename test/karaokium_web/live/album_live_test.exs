defmodule KaraokiumWeb.AlbumLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.RepertoireFixtures

  @create_attrs %{
    album_type: "some album_type",
    name: "some name",
    release_date: "some release_date",
    spotify_id: "some spotify_id",
    spotify_uri: "some spotify_uri",
    total_tracks: "some total_tracks"
  }
  @update_attrs %{
    album_type: "some updated album_type",
    name: "some updated name",
    release_date: "some updated release_date",
    spotify_id: "some updated spotify_id",
    spotify_uri: "some updated spotify_uri",
    total_tracks: "some updated total_tracks"
  }
  @invalid_attrs %{
    album_type: nil,
    name: nil,
    release_date: nil,
    spotify_id: nil,
    spotify_uri: nil,
    total_tracks: nil
  }

  defp create_album(_) do
    album = album_fixture()
    %{album: album}
  end

  describe "Index" do
    setup [:create_album]

    test "lists all albums", %{conn: conn, album: album} do
      {:ok, _index_live, html} = live(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Listing Albums"
      assert html =~ album.album_type
    end

    test "saves new album", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("a", "New Album") |> render_click() =~
               "New Album"

      assert_patch(index_live, Routes.album_index_path(conn, :new))

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Album created successfully"
      assert html =~ "some album_type"
    end

    test "updates album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("#album-#{album.id} a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(index_live, Routes.album_index_path(conn, :edit, album))

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Album updated successfully"
      assert html =~ "some updated album_type"
    end

    test "deletes album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("#album-#{album.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#album-#{album.id}")
    end
  end

  describe "Show" do
    setup [:create_album]

    test "displays album", %{conn: conn, album: album} do
      {:ok, _show_live, html} = live(conn, Routes.album_show_path(conn, :show, album))

      assert html =~ "Show Album"
      assert html =~ album.album_type
    end

    test "updates album within modal", %{conn: conn, album: album} do
      {:ok, show_live, _html} = live(conn, Routes.album_show_path(conn, :show, album))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(show_live, Routes.album_show_path(conn, :edit, album))

      assert show_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_show_path(conn, :show, album))

      assert html =~ "Album updated successfully"
      assert html =~ "some updated album_type"
    end
  end
end
