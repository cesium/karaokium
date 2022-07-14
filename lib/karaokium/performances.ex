defmodule Karaokium.Performances do
  @moduledoc """
  The Performances context.
  """

  import Ecto.Query, warn: false
  alias Karaokium.Repo

  alias Karaokium.Events.Karaoke
  alias Karaokium.Performances.Performance

  def get_ranking(%Karaoke{} = karaoke) do
    from(q in Performance, where: q.karaoke_id == ^karaoke.id, preload: [:votes, :team, :song])
    |> Repo.all()
    |> Enum.map(&Map.put(&1, :score, Performance.score(&1)))
    |> Enum.sort_by(& &1.score, :desc)
    |> Enum.uniq_by(& &1.team_id)
  end

  @doc """
  Returns the list of performances.

  ## Examples

      iex> list_performances()
      [%Performance{}, ...]

  """
  def list_performances do
    Repo.all(Performance)
  end

  @doc """
  Gets a single performance.

  Raises `Ecto.NoResultsError` if the Performance does not exist.

  ## Examples

      iex> get_performance!(123)
      %Performance{}

      iex> get_performance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_performance!(id), do: Repo.get!(Performance, id)

  def get_performance!(id, preloads \\ []),
    do: Repo.get!(Performance, id) |> Repo.preload(preloads)

  @doc """
  Creates a performance.

  ## Examples

      iex> create_performance(%{field: value})
      {:ok, %Performance{}}

      iex> create_performance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_performance(attrs \\ %{}) do
    %Performance{}
    |> Performance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a performance.

  ## Examples

      iex> update_performance(performance, %{field: new_value})
      {:ok, %Performance{}}

      iex> update_performance(performance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_performance(%Performance{} = performance, attrs) do
    performance
    |> Performance.changeset(attrs)
    |> Repo.update()
    |> broadcast(:updated)
  end

  @doc """
  Deletes a performance.

  ## Examples

      iex> delete_performance(performance)
      {:ok, %Performance{}}

      iex> delete_performance(performance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_performance(%Performance{} = performance) do
    Repo.delete(performance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking performance changes.

  ## Examples

      iex> change_performance(performance)
      %Ecto.Changeset{data: %Performance{}}

  """
  def change_performance(%Performance{} = performance, attrs \\ %{}) do
    Performance.changeset(performance, attrs)
  end

  def subscribe(topic) when topic in ["performances"] do
    Phoenix.PubSub.subscribe(Karaokium.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Performance{} = performance}, event)
       when event in [:updated] do
    Phoenix.PubSub.broadcast!(Karaokium.PubSub, "performances", {event, performance})
    {:ok, performance}
  end
end
