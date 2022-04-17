defmodule KaraokiumWeb.PageController do
  use KaraokiumWeb, :controller

  @app Mix.Project.config()[:app]
  @version Mix.Project.config()[:version]
  @description Mix.Project.config()[:description]
  @git_ref Mix.Project.config()[:git_ref]

  def index(conn, _params) do
    client_id = ""
    client_secret = ""

    IO.inspect(
      HTTPoison.request(
        :post,
        "https://accounts.spotify.com/api/token",
        "grant_type=client_credentials",
        [
          {"Content-Type", "application/x-www-form-urlencoded"},
          {"Authorization", "Basic " <> Base.encode64(client_id <> ":" <> client_secret)}
        ]
      )
    )

    render(conn, "index.html")
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
