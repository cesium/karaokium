defmodule Karaokium.PollingTest do
  use Karaokium.DataCase

  alias Karaokium.Polling

  describe "votes" do
    alias Karaokium.Polling.Vote

    import Karaokium.PollingFixtures

    @invalid_attrs %{pontuation: nil}

    test "list_votes/0 returns all votes" do
      vote = vote_fixture()
      assert Polling.list_votes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert Polling.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      valid_attrs = %{pontuation: 42}

      assert {:ok, %Vote{} = vote} = Polling.create_vote(valid_attrs)
      assert vote.pontuation == 42
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Polling.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      update_attrs = %{pontuation: 43}

      assert {:ok, %Vote{} = vote} = Polling.update_vote(vote, update_attrs)
      assert vote.pontuation == 43
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Polling.update_vote(vote, @invalid_attrs)
      assert vote == Polling.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = Polling.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> Polling.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = Polling.change_vote(vote)
    end
  end
end
