defmodule KaraokiumWeb.LocationLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.EventsFixtures

  @create_attrs %{address: "some address", county: "some county", district: "some district", locality: "some locality", name: "some name"}
  @update_attrs %{address: "some updated address", county: "some updated county", district: "some updated district", locality: "some updated locality", name: "some updated name"}
  @invalid_attrs %{address: nil, county: nil, district: nil, locality: nil, name: nil}

  defp create_location(_) do
    location = location_fixture()
    %{location: location}
  end

  describe "Index" do
    setup [:create_location]

    test "lists all locations", %{conn: conn, location: location} do
      {:ok, _index_live, html} = live(conn, Routes.location_index_path(conn, :index))

      assert html =~ "Listing Locations"
      assert html =~ location.address
    end

    test "saves new location", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

      assert index_live |> element("a", "New Location") |> render_click() =~
               "New Location"

      assert_patch(index_live, Routes.location_index_path(conn, :new))

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#location-form", location: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.location_index_path(conn, :index))

      assert html =~ "Location created successfully"
      assert html =~ "some address"
    end

    test "updates location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

      assert index_live |> element("#location-#{location.id} a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(index_live, Routes.location_index_path(conn, :edit, location))

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#location-form", location: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.location_index_path(conn, :index))

      assert html =~ "Location updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

      assert index_live |> element("#location-#{location.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#location-#{location.id}")
    end
  end

  describe "Show" do
    setup [:create_location]

    test "displays location", %{conn: conn, location: location} do
      {:ok, _show_live, html} = live(conn, Routes.location_show_path(conn, :show, location))

      assert html =~ "Show Location"
      assert html =~ location.address
    end

    test "updates location within modal", %{conn: conn, location: location} do
      {:ok, show_live, _html} = live(conn, Routes.location_show_path(conn, :show, location))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(show_live, Routes.location_show_path(conn, :edit, location))

      assert show_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#location-form", location: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.location_show_path(conn, :show, location))

      assert html =~ "Location updated successfully"
      assert html =~ "some updated address"
    end
  end
end
