defmodule Customs do
  def parse_group(input) do
    input
    |> String.replace(~r/\s/, "")
    |> String.graphemes()
    |> MapSet.new()
    |> MapSet.size()
  end

  def parse_group_p2(input) do
    input
    |> String.split()
    |> Enum.map(fn v -> v |> String.graphemes() |> MapSet.new() end)
    |> Enum.reduce(fn v, acc -> MapSet.intersection(v, acc) end)
  end
end
