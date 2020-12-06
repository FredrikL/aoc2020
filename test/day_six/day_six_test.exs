defmodule DaySix.DaySixTest do
  use ExUnit.Case

  test "Example input" do
    ex = "abcx
abcy
abcz"

    assert Customs.parse_group(ex) == 6
  end

  test "Multiple groups" do
    ex = "abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b"

    groups = ex |> String.split("\n\n")

    parsed = groups |> Enum.map(&Customs.parse_group/1)
    sum = Enum.reduce(parsed, 0, fn v, acc -> v + acc end)

    assert sum == 11
  end

  test "should handle puzzle input p1" do
    {:ok, input} = File.read("./test/day_six/input")

    groups = input |> String.split("\n\n")

    parsed = groups |> Enum.map(&Customs.parse_group/1)
    sum = Enum.reduce(parsed, 0, fn v, acc -> v + acc end)

    assert sum == 6532
  end

  test "p2 rules example" do
    ex = "abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b"

    groups = ex |> String.split("\n\n")

    parsed = groups |> Enum.map(&Customs.parse_group_p2/1)

    sizes = Enum.map(parsed, &MapSet.size/1)
    sum = Enum.reduce(sizes, 0, fn v, acc -> v + acc end)

    assert sum == 6
  end

  test "should handle puzzle input p2 rules" do
    {:ok, input} = File.read("./test/day_six/input")

    groups = input |> String.split("\n\n")

    parsed = groups |> Enum.map(&Customs.parse_group_p2/1)
    sizes = Enum.map(parsed, &MapSet.size/1)
    sum = Enum.reduce(sizes, 0, fn v, acc -> v + acc end)

    assert sum == 3427
  end
end
