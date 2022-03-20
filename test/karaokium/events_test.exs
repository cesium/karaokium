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
      valid_attrs = %{address: "some address", county: "some county", district: "some district", locality: "some locality", name: "some name"}

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
      update_attrs = %{address: "some updated address", county: "some updated county", district: "some updated district", locality: "some updated locality", name: "some updated name"}

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
end
