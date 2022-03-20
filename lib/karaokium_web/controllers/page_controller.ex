defmodule KaraokiumWeb.PageController do
  use KaraokiumWeb, :controller

  def index(conn, _params) do
    client_id = "bd3b54475948495ebf3ed44efd20c31b"
    client_secret = "744b91b2adb2420a900ca1de3c1a6d59"

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
