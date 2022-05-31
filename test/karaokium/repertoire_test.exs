defmodule Karaokium.RepertoireTest do
  use Karaokium.DataCase

  alias Karaokium.Repertoire

  describe "artists" do
    alias Karaokium.Repertoire.Artist

    import Karaokium.RepertoireFixtures

    @invalid_attrs %{href: nil, name: nil, spotify_id: nil, spotify_uri: nil, spotify_url: nil}

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Repertoire.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Repertoire.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      valid_attrs = %{
        href: "some href",
        name: "some name",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        spotify_url: "some spotify_url"
      }

      assert {:ok, %Artist{} = artist} = Repertoire.create_artist(valid_attrs)
      assert artist.href == "some href"
      assert artist.name == "some name"
      assert artist.spotify_id == "some spotify_id"
      assert artist.spotify_uri == "some spotify_uri"
      assert artist.spotify_url == "some spotify_url"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repertoire.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()

      update_attrs = %{
        href: "some updated href",
        name: "some updated name",
        spotify_id: "some updated spotify_id",
        spotify_uri: "some updated spotify_uri",
        spotify_url: "some updated spotify_url"
      }

      assert {:ok, %Artist{} = artist} = Repertoire.update_artist(artist, update_attrs)
      assert artist.href == "some updated href"
      assert artist.name == "some updated name"
      assert artist.spotify_id == "some updated spotify_id"
      assert artist.spotify_uri == "some updated spotify_uri"
      assert artist.spotify_url == "some updated spotify_url"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Repertoire.update_artist(artist, @invalid_attrs)
      assert artist == Repertoire.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Repertoire.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Repertoire.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Repertoire.change_artist(artist)
    end
  end

  describe "albums" do
    alias Karaokium.Repertoire.Album

    import Karaokium.RepertoireFixtures

    @invalid_attrs %{
      album_type: nil,
      name: nil,
      release_date: nil,
      spotify_id: nil,
      spotify_uri: nil,
      total_tracks: nil
    }

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Repertoire.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Repertoire.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      valid_attrs = %{
        album_type: :single,
        name: "some name",
        release_date: "some release_date",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        total_tracks: 18
      }

      assert {:ok, %Album{} = album} = Repertoire.create_album(valid_attrs)
      assert album.album_type == :single
      assert album.name == "some name"
      assert album.release_date == "some release_date"
      assert album.spotify_id == "some spotify_id"
      assert album.spotify_uri == "some spotify_uri"
      assert album.total_tracks == 18
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repertoire.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()

      update_attrs = %{
        album_type: :compilation,
        name: "some updated name",
        release_date: "some updated release_date",
        spotify_id: "some updated spotify_id",
        spotify_uri: "some updated spotify_uri",
        total_tracks: 12
      }

      assert {:ok, %Album{} = album} = Repertoire.update_album(album, update_attrs)

      assert album.album_type == :compilation
      assert album.name == "some updated name"

      assert album.release_date == "some updated release_date"
      assert album.spotify_id == "some updated spotify_id"
      assert album.spotify_uri == "some updated spotify_uri"
      assert album.total_tracks == 12
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Repertoire.update_album(album, @invalid_attrs)
      assert album == Repertoire.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Repertoire.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Repertoire.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Repertoire.change_album(album)
    end
  end

  describe "songs" do
    alias Karaokium.Repertoire.Song

    import Karaokium.RepertoireFixtures

    @invalid_attrs %{
      duration_ms: nil,
      explicit: nil,
      href: nil,
      name: nil,
      popularity: nil,
      preview_url: nil,
      spotify_id: nil,
      spotify_uri: nil,
      spotify_url: nil,
      track_number: nil
    }

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Repertoire.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Repertoire.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      valid_attrs = %{
        duration_ms: 230,
        explicit: true,
        href: "some href",
        name: "some name",
        popularity: 42,
        preview_url: "some preview_url",
        spotify_id: "some spotify_id",
        spotify_uri: "some spotify_uri",
        spotify_url: "some spotify_url",
        track_number: 2
      }

      assert {:ok, %Song{} = song} = Repertoire.create_song(valid_attrs)
      assert song.duration_ms == 230
      assert song.explicit == true
      assert song.href == "some href"
      assert song.name == "some name"
      assert song.popularity == 42
      assert song.preview_url == "some preview_url"
      assert song.spotify_id == "some spotify_id"
      assert song.spotify_uri == "some spotify_uri"
      assert song.spotify_url == "some spotify_url"
      assert song.track_number == 2
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repertoire.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()

      update_attrs = %{
        duration_ms: 120,
        explicit: false,
        href: "some updated href",
        name: "some updated name",
        popularity: 43,
        preview_url: "some updated preview_url",
        spotify_id: "some updated spotify_id",
        spotify_uri: "some updated spotify_uri",
        spotify_url: "some updated spotify_url",
        track_number: 4
      }

      assert {:ok, %Song{} = song} = Repertoire.update_song(song, update_attrs)
      assert song.duration_ms == 120
      assert song.explicit == false
      assert song.href == "some updated href"
      assert song.name == "some updated name"
      assert song.popularity == 43
      assert song.preview_url == "some updated preview_url"
      assert song.spotify_id == "some updated spotify_id"
      assert song.spotify_uri == "some updated spotify_uri"
      assert song.spotify_url == "some updated spotify_url"
      assert song.track_number == 4
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Repertoire.update_song(song, @invalid_attrs)
      assert song == Repertoire.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Repertoire.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Repertoire.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Repertoire.change_song(song)
    end
  end
end
