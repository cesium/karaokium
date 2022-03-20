defmodule KaraokiumWeb.VoteLiveTest do
  use KaraokiumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Karaokium.PollingFixtures

  @create_attrs %{pontuation: 42}
  @update_attrs %{pontuation: 43}
  @invalid_attrs %{pontuation: nil}

  defp create_vote(_) do
    vote = vote_fixture()
    %{vote: vote}
  end

  describe "Index" do
    setup [:create_vote]

    test "lists all votes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.vote_index_path(conn, :index))

      assert html =~ "Listing Votes"
    end

    test "saves new vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.vote_index_path(conn, :index))

      assert index_live |> element("a", "New Vote") |> render_click() =~
               "New Vote"

      assert_patch(index_live, Routes.vote_index_path(conn, :new))

      assert index_live
             |> form("#vote-form", vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vote-form", vote: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vote_index_path(conn, :index))

      assert html =~ "Vote created successfully"
    end

    test "updates vote in listing", %{conn: conn, vote: vote} do
      {:ok, index_live, _html} = live(conn, Routes.vote_index_path(conn, :index))

      assert index_live |> element("#vote-#{vote.id} a", "Edit") |> render_click() =~
               "Edit Vote"

      assert_patch(index_live, Routes.vote_index_path(conn, :edit, vote))

      assert index_live
             |> form("#vote-form", vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vote-form", vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vote_index_path(conn, :index))

      assert html =~ "Vote updated successfully"
    end

    test "deletes vote in listing", %{conn: conn, vote: vote} do
      {:ok, index_live, _html} = live(conn, Routes.vote_index_path(conn, :index))

      assert index_live |> element("#vote-#{vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vote-#{vote.id}")
    end
  end

  describe "Show" do
    setup [:create_vote]

    test "displays vote", %{conn: conn, vote: vote} do
      {:ok, _show_live, html} = live(conn, Routes.vote_show_path(conn, :show, vote))

      assert html =~ "Show Vote"
    end

    test "updates vote within modal", %{conn: conn, vote: vote} do
      {:ok, show_live, _html} = live(conn, Routes.vote_show_path(conn, :show, vote))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vote"

      assert_patch(show_live, Routes.vote_show_path(conn, :edit, vote))

      assert show_live
             |> form("#vote-form", vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#vote-form", vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vote_show_path(conn, :show, vote))

      assert html =~ "Vote updated successfully"
    end
  end
end
