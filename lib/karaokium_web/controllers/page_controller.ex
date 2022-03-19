defmodule KaraokiumWeb.PageController do
  use KaraokiumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
