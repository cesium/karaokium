defmodule KaraokiumWeb.PageController do
  use KaraokiumWeb, :controller

  alias Karaokium.Events

  @app Mix.Project.config()[:app]
  @version Mix.Project.config()[:version]
  @description Mix.Project.config()[:description]
  @git_ref Mix.Project.config()[:git_ref]

  def index(conn, %{"karaoke" => %{"code" => code}}) do
    case Events.get_karaoke_by_code(code) do
      nil ->
        conn
        |> put_flash(:error, "Invalid PIN")
        |> render("index.html")

      karaoke ->
        conn
        |> redirect(to: Routes.karaoke_show_path(conn, :show, karaoke))
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def goto(conn, _params) do
    redirect(conn, to: "/karaokium")
  end

  def about(conn, _params) do
    conn
    |> json(%{
      app: @app,
      version: @version,
      description: @description,
      git_ref: String.slice(@git_ref, 0, 7)
    })
  end

  def version(conn, _params) do
    conn
    |> text(@git_ref)
  end
end
