defmodule DayTen.DayTenTest do
  use ExUnit.Case

  @short_input "16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4"

  @long_input "28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3"

  test "handle small test input" do
    input =
      @short_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step(0, input)
    count = [Enum.count(result, &(&1 == 1)), Enum.count(result, &(&1 == 3))]

    assert [7, 5] == count
  end

  test "handle long test input" do
    input =
      @long_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step(0, input)
    count = [Enum.count(result, &(&1 == 1)), Enum.count(result, &(&1 == 3))]

    assert [22, 10] == count
  end

  test "handle p1 input" do
    input =
      File.read!("./test/day_ten/input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step(0, input)

    count = [Enum.count(result, &(&1 == 1)), Enum.count(result, &(&1 == 3))]

    assert [64, 31] == count
  end

  test "should return next steps" do
    input =
      @short_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = get_next_potential_indexes(0, input)
    assert result == [0]
    result = get_next_potential_indexes(1, Enum.slice(input, 1..5))
    assert result == [0]
    result = get_next_potential_indexes(4, Enum.slice(input, 2..5))
    assert result == [0, 1, 2]
  end

  test "count paths in short input" do
    input =
      @short_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step_all(0, input) |> List.flatten() |> Enum.sum()

    assert result == 8
  end

  test "count paths in long input" do
    input =
      @long_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step_all(0, input) |> List.flatten() |> Enum.sum()

    assert result == 19208
  end

  @tag :skip
  test "count paths in p1 input, bork bork" do
    input =
      File.read!("./test/day_ten/input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    result = step_all(0, input) |> List.flatten() |> Enum.sum()

    assert result == 19208
  end

  @tag :skip
  test "meh" do
    ## From forums since meh
    input =
      File.read!("./test/day_ten/input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    x =
      find_consecutive(input)
      |> Enum.map(&to_perm/1)
      |> Enum.reduce(&Kernel.*/2)

    IO.inspect(x)
  end

  test "meh short" do
    input =
      @short_input
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)
      |> Enum.sort()

    x =
      find_consecutive(input)
      |> Enum.map(&to_perm/1)
      |> Enum.reduce(&Kernel.*/2)
  end

  def to_perm(1), do: 1
  def to_perm(n), do: to_perm(n - 1) + n - 2

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  defp find_consecutive(input) do
    {return, _} =
      Enum.reduce(input, {[1], 0}, fn el, {[h | t] = l, prev} ->
        if el - prev == 1 do
          {[h + 1 | t], el}
        else
          {[1 | l], el}
        end
      end)

    return
  end

  def step(current, next_items) do
    next_index = hd(get_next_potential_indexes(current, next_items))
    next = Enum.at(next_items, next_index)
    diff = next - current

    new_next = Enum.slice(next_items, 1, length(next_items) - 1)

    if(new_next != []) do
      [diff] ++ step(next, new_next)
    else
      [diff, 3]
    end
  end

  def step_all(current, next_items) do
    next_index = get_next_potential_indexes(current, next_items)
    l = length(next_items)

    if next_index != [] do
      next_index
      |> Enum.map(fn idx ->
        next = Enum.at(next_items, idx)
        new_next = Enum.slice(next_items, idx + 1, l - idx)
        step_all(next, new_next)
      end)
    else
      [1]
    end
  end

  def get_next_potential_indexes(current, next_items) do
    Enum.slice(next_items, 0..2)
    |> Enum.with_index()
    |> Enum.filter(fn {e, _i} -> if e - current <= 3, do: true, else: false end)
    |> Enum.map(fn {_e, i} -> i end)
  end
end
