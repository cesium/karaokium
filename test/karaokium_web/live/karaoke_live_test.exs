defmodule KaraokiumWeb.KaraokeLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.EventsFixtures

  @create_attrs %{
    end_date: %{day: 19, month: 3, year: 2022},
    name: "some name",
    start_date: %{day: 19, month: 3, year: 2022}
  }
  @update_attrs %{
    end_date: %{day: 20, month: 3, year: 2022},
    name: "some updated name",
    start_date: %{day: 20, month: 3, year: 2022}
  }
  @invalid_attrs %{
    end_date: %{day: 30, month: 2, year: 2022},
    name: nil,
    start_date: %{day: 30, month: 2, year: 2022}
  }

  defp create_karaoke(_) do
    karaoke = karaoke_fixture()
    %{karaoke: karaoke}
  end

  describe "Index" do
    setup [:create_karaoke]

    test "lists all karaokes", %{conn: conn, karaoke: karaoke} do
      {:ok, _index_live, html} = live(conn, Routes.karaoke_index_path(conn, :index))

      assert html =~ "Listing Karaokes"
      assert html =~ karaoke.name
    end

    test "saves new karaoke", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.karaoke_index_path(conn, :index))

      assert index_live |> element("a", "New Karaoke") |> render_click() =~
               "New Karaoke"

      assert_patch(index_live, Routes.karaoke_index_path(conn, :new))

      assert index_live
             |> form("#karaoke-form", karaoke: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#karaoke-form", karaoke: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.karaoke_index_path(conn, :index))

      assert html =~ "Karaoke created successfully"
      assert html =~ "some name"
    end

    test "updates karaoke in listing", %{conn: conn, karaoke: karaoke} do
      {:ok, index_live, _html} = live(conn, Routes.karaoke_index_path(conn, :index))

      assert index_live |> element("#karaoke-#{karaoke.id} a", "Edit") |> render_click() =~
               "Edit Karaoke"

      assert_patch(index_live, Routes.karaoke_index_path(conn, :edit, karaoke))

      assert index_live
             |> form("#karaoke-form", karaoke: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#karaoke-form", karaoke: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.karaoke_index_path(conn, :index))

      assert html =~ "Karaoke updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes karaoke in listing", %{conn: conn, karaoke: karaoke} do
      {:ok, index_live, _html} = live(conn, Routes.karaoke_index_path(conn, :index))

      assert index_live |> element("#karaoke-#{karaoke.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#karaoke-#{karaoke.id}")
    end
  end

  describe "Show" do
    setup [:create_karaoke]

    test "displays karaoke", %{conn: conn, karaoke: karaoke} do
      {:ok, _show_live, html} = live(conn, Routes.karaoke_show_path(conn, :show, karaoke))

      assert html =~ "Show Karaoke"
      assert html =~ karaoke.name
    end

    test "updates karaoke within modal", %{conn: conn, karaoke: karaoke} do
      {:ok, show_live, _html} = live(conn, Routes.karaoke_show_path(conn, :show, karaoke))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Karaoke"

      assert_patch(show_live, Routes.karaoke_show_path(conn, :edit, karaoke))

      assert show_live
             |> form("#karaoke-form", karaoke: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#karaoke-form", karaoke: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.karaoke_show_path(conn, :show, karaoke))

      assert html =~ "Karaoke updated successfully"
      assert html =~ "some updated name"
    end
  end
end
