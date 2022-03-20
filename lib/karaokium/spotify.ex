defmodule Karaokium.Spotify do
  @client_id
  @client_secret

  def get_token() do
    body = "grant_type=client_credentials"

    header = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic " <> encode_token()}
    ]

    case HTTPoison.request(:post, "https://accounts.spotify.com/api/token", body, header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body, label: "200")

      {:ok, %HTTPoison.Response{} = response} ->
        IO.inspect(response)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp encode_token do
    Base.encode64(@client_id <> ":" <> @client_secret)
  end
end
