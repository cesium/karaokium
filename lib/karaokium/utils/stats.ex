defmodule Karaokium.Utils.Stats do
  def mean([]), do: nil
  def mean(list), do: Enum.sum(list) / length(list)

  def median([]), do: nil

  def median(list) do
    len = length(list)
    sorted = Enum.sort(list)
    mid = div(len, 2)

    if rem(len, 2) == 0 do
      (Enum.at(sorted, mid - 1) + Enum.at(sorted, mid)) / 2
    else
      Enum.at(sorted, mid)
    end
  end
end
