defmodule Karaokium.Spotify do
  @app Mix.Project.config()[:app]

  require Logger

  def get_token do
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=client_credentials"

    header = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic " <> encode_token()}
    ]

    case HTTPoison.request(:post, url, body, header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        access_token =
          body
          |> Jason.decode!()
          |> Map.fetch!("access_token")

        {:ok, access_token}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)

        {:error, reason}
    end
  end

  def search(query, type \\ "track") when type in ["track", "artist"] do
    {:ok, token} = get_token()

    query =
      query
      |> URI.encode()

    url = "https://api.spotify.com/v1/search"

    header = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer " <> token}
    ]

    case HTTPoison.get(url <> "?q=#{query}&type=#{type}", header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("tracks")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)

        {:error, reason}
    end
  end

  def get_track(spotify_id) do
    {:ok, token} = get_token()

    url = "https://api.spotify.com/v1/tracks/"

    header = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer " <> token}
    ]

    case HTTPoison.get(url <> "#{spotify_id}", header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)

        {:error, reason}
    end
  end

  defp encode_token do
    Base.encode64(client_id() <> ":" <> client_secret())
  end

  defp client_id do
    Application.get_env(@app, __MODULE__)[:client_id]
  end

  defp client_secret do
    Application.get_env(@app, __MODULE__)[:client_secret]
  end
end
