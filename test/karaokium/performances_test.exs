defmodule Karaokium.PerformancesTest do
  use Karaokium.DataCase

  alias Karaokium.Performances

  describe "performances" do
    alias Karaokium.Performances.Performance

    import Karaokium.PerformancesFixtures
    import Karaokium.RepertoireFixtures
    import Karaokium.EventsFixtures
    import Karaokium.GroupsFixtures

    @invalid_attrs %{}

    test "list_performances/0 returns all performances" do
      performance = performance_fixture()
      assert Performances.list_performances() == [performance]
    end

    test "get_performance!/1 returns the performance with given id" do
      performance = performance_fixture()
      assert Performances.get_performance!(performance.id) == performance
    end

    test "create_performance/1 with valid data creates a performance" do
      valid_attrs = %{
        song_id: song_fixture().id,
        karaoke_id: karaoke_fixture().id,
        team_id: team_fixture().id
      }

      assert {:ok, %Performance{} = _performance} = Performances.create_performance(valid_attrs)
    end

    test "create_performance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Performances.create_performance(@invalid_attrs)
    end

    test "update_performance/2 with valid data updates the performance" do
      performance = performance_fixture()
      update_attrs = %{}

      assert {:ok, %Performance{} = _performance} =
               Performances.update_performance(performance, update_attrs)
    end

    test "delete_performance/1 deletes the performance" do
      performance = performance_fixture()
      assert {:ok, %Performance{}} = Performances.delete_performance(performance)
      assert_raise Ecto.NoResultsError, fn -> Performances.get_performance!(performance.id) end
    end

    test "change_performance/1 returns a performance changeset" do
      performance = performance_fixture()
      assert %Ecto.Changeset{} = Performances.change_performance(performance)
    end
  end
end
