defmodule KaraokiumWeb.PageControllerTest do
  use KaraokiumWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "redirected</a>"
  end

  test "GET /karaokium", %{conn: conn} do
    conn = get(conn, "/karaokium")
    assert html_response(conn, 200) =~ "<h1>Welcome to Karaokium!</h1>"
  end
end
