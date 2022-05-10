defmodule Karaokium.Utils.Naming do
  @moduledoc """
  Conveniences for inflecting and working with names.
  """

  @doc """
  Gets the first word from a string.

  ## Examples

    iex> Karaokium.Naming.first_name("Nelson Estevão")
    "Nelson"
    iex> Karaokium.Naming.first_name("carlos")
    "Carlos"
    iex> Karaokium.Naming.first_name("CeSIUM")
    "CeSIUM"
  """
  @spec first_name(String.t()) :: String.t()
  def first_name(full_name) do
    full_name
    |> String.split(" ")
    |> List.first()
    |> Phoenix.Naming.camelize()
  end

  @spec underscore(String.t()) :: String.t()
  defdelegate underscore(string), to: Phoenix.Naming
end
