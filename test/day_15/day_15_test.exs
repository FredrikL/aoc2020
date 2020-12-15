defmodule Day15.Day15Test do
  use ExUnit.Case

  test "ex 1" do
    start = [0, 3, 6]
    res = next(start)
    assert res == [0, 3, 6, 0]

    res = next(res)
    assert res == [0, 3, 6, 0, 3]

    res = next(res)
    assert res == [0, 3, 6, 0, 3, 3]

    res = next(res)
    assert res == [0, 3, 6, 0, 3, 3, 1]
    res = next(res)
    assert res == [0, 3, 6, 0, 3, 3, 1, 0]
    res = next(res)
    assert res == [0, 3, 6, 0, 3, 3, 1, 0, 4]
    res = next(res)
    assert res == [0, 3, 6, 0, 3, 3, 1, 0, 4, 0]
  end

  test "run ex1 to turn 2020" do
    start = [0, 3, 6]
    result = loop(start)
    last = Enum.at(result, -1)
    assert last == 436
  end

  test "validation" do
    # assert Enum.at(loop([1, 3, 2]), -1) == 1
    # assert Enum.at(loop([2, 1, 3]), -1) == 10
    # assert Enum.at(loop([1, 2, 3]), -1) == 27
    # assert Enum.at(loop([2, 3, 1]), -1) == 78
    # assert Enum.at(loop([3, 2, 1]), -1) == 438
    # assert Enum.at(loop([3, 1, 2]), -1) == 1836
  end

  test "p1" do
    assert Enum.at(loop([1, 20, 11, 6, 12, 0]), -1) == 1085
  end

  defp loop(numbers, age \\ 2020) do
    if(length(numbers) < age) do
      loop(next(numbers), age)
    else
      numbers
    end
  end

  defp loop_2(last, pos, map, age \\ 2020) do
    if(pos < age) do
      {last_, pos_, map_} = next(last, pos, map)
      loop_2(last_, pos_, map_, age)
    else
      {last, pos, map}
    end
  end

  ## Use map? 0: [arr with pos?]
  defp next(last, pos, map) do
    c_last = map[last]
    # IO.inspect(c_last)

    if(length(c_last) == 1) do
      {0, pos + 1, Map.put(map, 0, [pos | map[0]])}
    else
      [p1, p2] = c_last

      diff = p1 - p2
      # IO.puts(diff)

      m =
        if(Map.has_key?(map, diff)) do
          Map.put(map, diff, [pos, hd(map[diff])])
        else
          Map.put(map, diff, [pos])
        end

      {diff, pos + 1, m}
    end
  end

  defp next(data) do
    last = Enum.at(data, -1)

    if(Enum.count(data, &(&1 == last)) == 1) do
      data ++ [0]
    else
      [{_, p1}, {_, p2}] =
        data
        |> Enum.with_index()
        |> Enum.filter(fn {v, i} -> v == last end)
        |> Enum.take(-2)

      diff = p2 - p1
      data ++ [diff]
    end
  end
end
