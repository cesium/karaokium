defmodule Karaokium.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  import Karaokium.Context
  alias Karaokium.Repo

  alias Karaokium.Events.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations(opts \\ []) do
    Location
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id, preloads \\ []), do: Repo.get!(Location, id) |> Repo.preload(preloads)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  alias Karaokium.Events.Karaoke

  @doc """
  Returns the list of karaokes.

  ## Examples

      iex> list_karaokes()
      [%Karaoke{}, ...]

  """
  def list_karaokes(opts \\ []) do
    Karaoke
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single karaoke.

  Raises `Ecto.NoResultsError` if the Karaoke does not exist.

  ## Examples

      iex> get_karaoke!(123)
      %Karaoke{}

      iex> get_karaoke!(456)
      ** (Ecto.NoResultsError)

  """
  def get_karaoke!(id, preloads \\ []), do: Repo.get!(Karaoke, id) |> Repo.preload(preloads)

  def get_karaoke_by_code(code) when is_binary(code) do
    Repo.get_by(Karaoke, code: code)
  end

  @doc """
  Creates a karaoke.

  ## Examples

      iex> create_karaoke(%{field: value})
      {:ok, %Karaoke{}}

      iex> create_karaoke(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_karaoke(attrs \\ %{}) do
    %Karaoke{}
    |> Karaoke.create_changeset(attrs)
    |> Repo.insert()
  end

  def reset_pin_karaoke(%Karaoke{} = karaoke) do
    karaoke
    |> Karaoke.reset_pin_changeset()
    |> Repo.update()
    |> broadcast(:update)
  end

  @doc """
  Updates a karaoke.

  ## Examples

      iex> update_karaoke(karaoke, %{field: new_value})
      {:ok, %Karaoke{}}

      iex> update_karaoke(karaoke, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_karaoke(%Karaoke{} = karaoke, attrs) do
    karaoke
    |> Karaoke.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update)
  end

  @doc """
  Deletes a karaoke.

  ## Examples

      iex> delete_karaoke(karaoke)
      {:ok, %Karaoke{}}

      iex> delete_karaoke(karaoke)
      {:error, %Ecto.Changeset{}}

  """
  def delete_karaoke(%Karaoke{} = karaoke) do
    Repo.delete(karaoke)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking karaoke changes.

  ## Examples

      iex> change_karaoke(karaoke)
      %Ecto.Changeset{data: %Karaoke{}}

  """
  def change_karaoke(%Karaoke{} = karaoke, attrs \\ %{}) do
    Karaoke.changeset(karaoke, attrs)
  end

  def subscribe(topic) when topic in ["karaokes"] do
    Phoenix.PubSub.subscribe(Karaokium.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Karaoke{} = karaoke}, event)
       when event in [:update] do
    Phoenix.PubSub.broadcast!(Karaokium.PubSub, "karaokes", {event, karaoke})
    {:ok, karaoke}
  end
end
