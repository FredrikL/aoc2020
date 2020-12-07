defmodule Bags do
  def parse_lines(lines) do
    lines
    |> Enum.map(fn l ->
      [name, content] = String.split(l, "bags contain", parts: 2)
      %{remove_bags(name) => parse_content(content)}
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  defp remove_bags(color) do
    color
    |> String.trim()
    |> String.replace("bags", "")
    |> String.replace("bag", "")
    |> String.replace(".", "")
  end

  defp parse_content(content) do
    content
    |> String.split(",")
    |> Enum.map(fn v ->
      [count | bags] = String.split(v, " ", trim: true)

      case count do
        "no" ->
          %{}

        _ ->
          {num, _} = Integer.parse(count)
          [c1, c2, _] = bags
          %{"#{c1} #{c2}" => num}
      end
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  def walk_path(map, from, to) do
    contains = map[from]

    if(Map.has_key?(contains, to)) do
      true
    else
      if contains != %{} do
        Map.keys(contains)
        |> Enum.map(fn k -> walk_path(map, k, to) end)
        |> Enum.reduce(fn v, acc -> v or acc end)
      else
        false
      end
    end
  end

  def count_bags(map, key) do
    IO.puts(key)
    contains = map[key]
    IO.inspect(contains)

    if contains != %{} do
      bag =
        Map.keys(contains)
        |> Enum.map(fn k -> count_bags(map, k) * contains[k] + contains[k] end)

      IO.inspect(bag)
      Enum.sum(bag)
    else
      0
    end
  end
end
