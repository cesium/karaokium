defmodule Karaokium.RepertoireFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Karaokium.Repertoire` context.
  """

  @doc """
  Generate a artist.
  """
  def artist_fixture(attrs \\ %{}) do
    {:ok, artist} =
      attrs
      |> Enum.into(%{
        href: "some href",
        name: "some name",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        spotify_url: "some spotify_url"
      })
      |> Karaokium.Repertoire.create_artist()

    artist
  end

  @doc """
  Generate a song.
  """
  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(%{
        duration_ms: 230,
        explicit: true,
        href: "some href",
        name: "some name",
        popularity: 42,
        preview_url: "some preview_url",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        spotify_url: "some spotify_url",
        track_number: 1
      })
      |> Karaokium.Repertoire.create_song()

    song
  end

  @doc """
  Generate a album.
  """
  def album_fixture(attrs \\ %{}) do
    {:ok, album} =
      attrs
      |> Enum.into(%{
        album_type: Enum.random([:album, :single, :compilation]),
        name: "some name",
        release_date: "some release_date",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        total_tracks: 19
      })
      |> Karaokium.Repertoire.create_album()

    album
  end
end
