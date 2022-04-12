defmodule Karaokium.EventsTest do
  use Karaokium.DataCase

  alias Karaokium.Events

  describe "locations" do
    alias Karaokium.Events.Location

    import Karaokium.EventsFixtures

    @invalid_attrs %{address: nil, county: nil, district: nil, locality: nil, name: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Events.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Events.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{
        address: "some address",
        county: "some county",
        district: "some district",
        locality: "some locality",
        name: "some name"
      }

      assert {:ok, %Location{} = location} = Events.create_location(valid_attrs)
      assert location.address == "some address"
      assert location.county == "some county"
      assert location.district == "some district"
      assert location.locality == "some locality"
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()

      update_attrs = %{
        address: "some updated address",
        county: "some updated county",
        district: "some updated district",
        locality: "some updated locality",
        name: "some updated name"
      }

      assert {:ok, %Location{} = location} = Events.update_location(location, update_attrs)
      assert location.address == "some updated address"
      assert location.county == "some updated county"
      assert location.district == "some updated district"
      assert location.locality == "some updated locality"
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_location(location, @invalid_attrs)
      assert location == Events.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Events.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Events.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Events.change_location(location)
    end
  end

  describe "karaokes" do
    alias Karaokium.Events.Karaoke

    import Karaokium.EventsFixtures

    @invalid_attrs %{end_date: nil, name: nil, start_date: nil}

    test "list_karaokes/0 returns all karaokes" do
      karaoke = karaoke_fixture()
      assert Events.list_karaokes() == [karaoke]
    end

    test "get_karaoke!/1 returns the karaoke with given id" do
      karaoke = karaoke_fixture()
      assert Events.get_karaoke!(karaoke.id) == karaoke
    end

    test "create_karaoke/1 with valid data creates a karaoke" do
      valid_attrs = %{end_date: ~D[2022-03-19], name: "some name", start_date: ~D[2022-03-19]}

      assert {:ok, %Karaoke{} = karaoke} = Events.create_karaoke(valid_attrs)
      assert karaoke.end_date == ~D[2022-03-19]
      assert karaoke.name == "some name"
      assert karaoke.start_date == ~D[2022-03-19]
    end

    test "create_karaoke/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_karaoke(@invalid_attrs)
    end

    test "update_karaoke/2 with valid data updates the karaoke" do
      karaoke = karaoke_fixture()

      update_attrs = %{
        end_date: ~D[2022-03-20],
        name: "some updated name",
        start_date: ~D[2022-03-20]
      }

      assert {:ok, %Karaoke{} = karaoke} = Events.update_karaoke(karaoke, update_attrs)
      assert karaoke.end_date == ~D[2022-03-20]
      assert karaoke.name == "some updated name"
      assert karaoke.start_date == ~D[2022-03-20]
    end

    test "update_karaoke/2 with invalid data returns error changeset" do
      karaoke = karaoke_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_karaoke(karaoke, @invalid_attrs)
      assert karaoke == Events.get_karaoke!(karaoke.id)
    end

    test "delete_karaoke/1 deletes the karaoke" do
      karaoke = karaoke_fixture()
      assert {:ok, %Karaoke{}} = Events.delete_karaoke(karaoke)
      assert_raise Ecto.NoResultsError, fn -> Events.get_karaoke!(karaoke.id) end
    end

    test "change_karaoke/1 returns a karaoke changeset" do
      karaoke = karaoke_fixture()
      assert %Ecto.Changeset{} = Events.change_karaoke(karaoke)
    end
  end
end
