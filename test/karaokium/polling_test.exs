defmodule Karaokium.PollingTest do
  use Karaokium.DataCase

  alias Karaokium.Polling

  describe "votes" do
    alias Karaokium.Polling.Vote

    import Karaokium.AccountsFixtures
    import Karaokium.PerformancesFixtures
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
      valid_attrs = %{
        pontuation: 4,
        performance_id: performance_fixture().id,
        user_id: user_fixture().id
      }

      assert {:ok, %Vote{} = vote} = Polling.create_vote(valid_attrs)
      assert vote.pontuation == 4
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Polling.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      update_attrs = %{pontuation: 8}

      assert {:ok, %Vote{} = vote} = Polling.update_vote(vote, update_attrs)
      assert vote.pontuation == 8
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

  describe "reactions" do
    alias Karaokium.Polling.Reaction

    import Karaokium.AccountsFixtures
    import Karaokium.PerformancesFixtures
    import Karaokium.PollingFixtures

    @invalid_attrs %{emoji: nil}

    test "list_reactions/0 returns all reactions" do
      reaction = reaction_fixture()
      assert Polling.list_reactions() == [reaction]
    end

    test "get_reaction!/1 returns the reaction with given id" do
      reaction = reaction_fixture()
      assert Polling.get_reaction!(reaction.id) == reaction
    end

    test "create_reaction/1 with valid data creates a reaction" do
      valid_attrs = %{
        emoji: :"👍",
        performance_id: performance_fixture().id,
        user_id: user_fixture().id
      }

      assert {:ok, %Reaction{} = reaction} = Polling.create_reaction(valid_attrs)
      assert reaction.emoji == :"👍"
    end

    test "create_reaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Polling.create_reaction(@invalid_attrs)
    end

    test "update_reaction/2 with valid data updates the reaction" do
      reaction = reaction_fixture()
      update_attrs = %{emoji: :"❤️"}

      assert {:ok, %Reaction{} = reaction} = Polling.update_reaction(reaction, update_attrs)
      assert reaction.emoji == :"❤️"
    end

    test "update_reaction/2 with invalid data returns error changeset" do
      reaction = reaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Polling.update_reaction(reaction, @invalid_attrs)
      assert reaction == Polling.get_reaction!(reaction.id)
    end

    test "delete_reaction/1 deletes the reaction" do
      reaction = reaction_fixture()
      assert {:ok, %Reaction{}} = Polling.delete_reaction(reaction)
      assert_raise Ecto.NoResultsError, fn -> Polling.get_reaction!(reaction.id) end
    end

    test "change_reaction/1 returns a reaction changeset" do
      reaction = reaction_fixture()
      assert %Ecto.Changeset{} = Polling.change_reaction(reaction)
    end
  end
end
