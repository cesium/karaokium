defmodule Karaokium.Performances.Performance do
  @moduledoc """
  A Karaoke performance where the participants sing a music.
  """
  use Karaokium.Schema

  alias Karaokium.Events
  alias Karaokium.Groups
  alias Karaokium.Polling
  alias Karaokium.Repertoire
  alias Karaokium.Repo
  alias Karaokium.Utils.Stats

  schema "performances" do
    belongs_to :karaoke, Events.Karaoke
    belongs_to :team, Groups.Team
    belongs_to :song, Repertoire.Song

    field :score, :decimal, virtual: true

    has_many :votes, Polling.Vote
    has_many :reactions, Polling.Reaction

    field :voting?, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [:karaoke_id, :team_id, :song_id, :voting?])
    |> validate_required([:karaoke_id, :team_id, :song_id])
  end

  @doc """
  Calculates a performance's score.

  Uses [Wikipedia's first method](https://en.wikipedia.org/wiki/Quartile#Method_1) to calculate quartile values.
  From these, determines the outliers and excludes such values from the final average calculation.

  Preloads votes if they are not already loaded.
  Returns 0 if there are no votes.

  ## Examples

      iex> votes = [%Karaokium.Polling.Vote{pontuation: 1} | List.duplicate(%Karaokium.Polling.Vote{pontuation: 9}, 5)]
      iex> performance = %Karaokium.Performances.Performance{votes: votes}
      iex> Karaokium.Performances.Performance.score(performance)
      #Decimal<9.00>

      iex> performance = %Karaokium.Performances.Performance{votes: []}
      iex> Karaokium.Performances.Performance.score(performance))
      #Decimal<0>

  """
  def score(%__MODULE__{votes: %Ecto.Association.NotLoaded{}} = performance) do
    Repo.preload(performance, :votes)
    |> score()
  end

  def score(%__MODULE__{votes: []}), do: Decimal.new(0)

  def score(%__MODULE__{} = performance) do
    pontuations =
      performance.votes
      |> Enum.map(& &1.pontuation)
      |> Enum.sort()

    half = div(length(pontuations), 2)

    half =
      if half == 0 do
        1
      else
        half
      end

    q1 =
      pontuations
      |> Enum.take(half)
      |> Stats.median()

    q3 =
      pontuations
      |> Enum.take(-half)
      |> Stats.median()

    iqr = q3 - q1

    lower = q1 - 1.5 * iqr
    upper = q3 + 1.5 * iqr

    outliers = for p <- pontuations, p < lower or p > upper, do: p
    fixed = for p <- pontuations, p not in outliers, do: p

    fixed
    |> Stats.mean()
    |> Decimal.from_float()
    |> Decimal.round(2)
  end
end
