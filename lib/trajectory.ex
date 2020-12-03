defmodule Trajectory do
  def parse_input_str(input) do
    input
    |> String.split("\n")
    |> parse_input()
  end

  def parse_input(input) do
    input
    |> Enum.with_index(0)
    |> Enum.map(fn {v, k} ->
      value =
        v
        |> String.graphemes()
        |> Enum.with_index(0)
        |> Enum.map(fn {va, ky} -> %{} |> Map.put(ky, va) end)
        |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)

      %{}
      |> Map.put(k, value)
    end)
    |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)
  end

  def traverse(input, {x, y}, {right, down}) do
    if(y >= length(Map.keys(input))) do
      0
    else
      row = input[y]
      width = length(Map.keys(row))

      traverse(input, {rem(x + right, width), y + down}, {right, down}) +
        if(row[x] == "#") do
          1
        else
          0
        end
    end
  end
end
