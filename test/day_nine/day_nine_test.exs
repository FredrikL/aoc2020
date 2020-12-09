defmodule DayNine.DayNineTest do
  use ExUnit.Case

  # List comprehension!
  test "example data should be valid" do
    input = 1..25 |> Enum.to_list()

    assert length(in_preamble(input, 26)) > 0
    assert length(in_preamble(input, 49)) > 0
    assert length(in_preamble(input, 100)) == 0
    assert length(in_preamble(input, 50)) == 0
  end

  test "should handle expanded example data" do
    input = [20] ++ (1..19 |> Enum.to_list()) ++ [21, 22, 23, 24, 25, 45]

    assert length(in_preamble(input, 26, 1, 25)) > 0
    assert length(in_preamble(input, 64, 1, 25)) > 0
    assert length(in_preamble(input, 65, 1, 25)) == 0
    assert length(in_preamble(input, 66, 1, 25)) > 0
  end

  test "should find missing in list" do
    input = "35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576" |> String.split("\n") |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)

    result = find_not_valid(input, 0, 5)

    assert result == 127
  end

  test "should handle p1 input" do
    input =
      File.read!("./test/day_nine/input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)

    result = find_not_valid(input, 0, 25)

    assert result == 27_911_108
  end

  test "should find range that equals" do
    input =
      "35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576"
      |> String.split("\n")
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)

    range = find_range(input, 127) |> Enum.sort()
    l = hd(range)
    h = Enum.at(range, length(range) - 1)
    assert l + h == 62
  end

  test "should find range from p1 input" do
    input =
      File.read!("./test/day_nine/input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn v -> v |> String.trim() |> String.to_integer() end)

    range = find_range(input, 27_911_108) |> Enum.sort()
    l = hd(range)
    h = Enum.at(range, length(range) - 1)
    assert l + h == 4_023_754
  end

  def find_range(range, value, offset \\ 0) do
    case has_range(range, value, offset, 0) do
      {:found, v} ->
        v

      {:no} ->
        find_range(range, value, offset + 1)
    end
  end

  def has_range(range, value, offset, steps) do
    sum = Enum.slice(range, offset, steps) |> Enum.sum()

    if(sum == value) do
      {:found, Enum.slice(range, offset, steps) |> Enum.to_list()}
    else
      if sum < value do
        has_range(range, value, offset, steps + 1)
      else
        {:no}
      end
    end
  end

  def find_not_valid(preamble, offset, size) do
    value = Enum.at(preamble, offset + size)
    r = in_preamble(preamble, value, offset, size)

    if r != [] do
      find_not_valid(preamble, offset + 1, size)
    else
      value
    end
  end

  def in_preamble(preamble, value, offset, size) do
    Enum.slice(preamble, offset, size) |> in_preamble(value)
  end

  def in_preamble(preamble, value) do
    for a <- preamble, b <- preamble, a != b && a + b == value, do: value
  end
end
