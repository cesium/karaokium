defmodule KaraokiumWeb.PageController do
  use KaraokiumWeb, :controller

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
end
