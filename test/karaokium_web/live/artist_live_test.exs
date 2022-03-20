defmodule KaraokiumWeb.ArtistLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.RepertoireFixtures

  @create_attrs %{href: "some href", name: "some name", spotify_id: "some spotify_id", spotify_uri: "some spotify_uri", spotify_url: "some spotify_url"}
  @update_attrs %{href: "some updated href", name: "some updated name", spotify_id: "some updated spotify_id", spotify_uri: "some updated spotify_uri", spotify_url: "some updated spotify_url"}
  @invalid_attrs %{href: nil, name: nil, spotify_id: nil, spotify_uri: nil, spotify_url: nil}

  defp create_artist(_) do
    artist = artist_fixture()
    %{artist: artist}
  end

  describe "Index" do
    setup [:create_artist]

    test "lists all artists", %{conn: conn, artist: artist} do
      {:ok, _index_live, html} = live(conn, Routes.artist_index_path(conn, :index))

      assert html =~ "Listing Artists"
      assert html =~ artist.href
    end

    test "saves new artist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.artist_index_path(conn, :index))

      assert index_live |> element("a", "New Artist") |> render_click() =~
               "New Artist"

      assert_patch(index_live, Routes.artist_index_path(conn, :new))

      assert index_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#artist-form", artist: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.artist_index_path(conn, :index))

      assert html =~ "Artist created successfully"
      assert html =~ "some href"
    end

    test "updates artist in listing", %{conn: conn, artist: artist} do
      {:ok, index_live, _html} = live(conn, Routes.artist_index_path(conn, :index))

      assert index_live |> element("#artist-#{artist.id} a", "Edit") |> render_click() =~
               "Edit Artist"

      assert_patch(index_live, Routes.artist_index_path(conn, :edit, artist))

      assert index_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#artist-form", artist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.artist_index_path(conn, :index))

      assert html =~ "Artist updated successfully"
      assert html =~ "some updated href"
    end

    test "deletes artist in listing", %{conn: conn, artist: artist} do
      {:ok, index_live, _html} = live(conn, Routes.artist_index_path(conn, :index))

      assert index_live |> element("#artist-#{artist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#artist-#{artist.id}")
    end
  end

  describe "Show" do
    setup [:create_artist]

    test "displays artist", %{conn: conn, artist: artist} do
      {:ok, _show_live, html} = live(conn, Routes.artist_show_path(conn, :show, artist))

      assert html =~ "Show Artist"
      assert html =~ artist.href
    end

    test "updates artist within modal", %{conn: conn, artist: artist} do
      {:ok, show_live, _html} = live(conn, Routes.artist_show_path(conn, :show, artist))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Artist"

      assert_patch(show_live, Routes.artist_show_path(conn, :edit, artist))

      assert show_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#artist-form", artist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.artist_show_path(conn, :show, artist))

      assert html =~ "Artist updated successfully"
      assert html =~ "some updated href"
    end
  end
end
