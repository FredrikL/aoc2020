defmodule DaySeven.DaySevenTest do
  use ExUnit.Case

  @data "light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags."

  test "should parse test input" do
    lines = @data |> String.split("\n") |> Enum.map(&String.trim/1)

    result = Bags.parse_lines(lines)

    assert result == %{
             "bright white" => %{"shiny gold" => 1},
             "dark olive" => %{"dotted black" => 4, "faded blue" => 3},
             "dark orange" => %{"bright white" => 3, "muted yellow" => 4},
             "dotted black" => %{},
             "faded blue" => %{},
             "light red" => %{"bright white" => 1, "muted yellow" => 2},
             "muted yellow" => %{"faded blue" => 9, "shiny gold" => 2},
             "shiny gold" => %{"dark olive" => 1, "vibrant plum" => 2},
             "vibrant plum" => %{"dotted black" => 6, "faded blue" => 5}
           }
  end

  test "should check path" do
    lines = @data |> String.split("\n") |> Enum.map(&String.trim/1)

    map = Bags.parse_lines(lines)

    assert Bags.walk_path(map, "shiny gold", "shiny gold") == false
    assert Bags.walk_path(map, "faded blue", "shiny gold") == false
    assert Bags.walk_path(map, "dotted black", "shiny gold") == false
    assert Bags.walk_path(map, "bright white", "shiny gold") == true
    assert Bags.walk_path(map, "muted yellow", "shiny gold") == true
    assert Bags.walk_path(map, "dark orange", "shiny gold") == true
    assert Bags.walk_path(map, "light red", "shiny gold") == true
  end

  test "should calculate examples" do
    lines = @data |> String.split("\n") |> Enum.map(&String.trim/1)

    map = Bags.parse_lines(lines)

    sum =
      Map.keys(map)
      |> Enum.map(fn k -> if Bags.walk_path(map, k, "shiny gold"), do: 1, else: 0 end)
      |> Enum.sum()

    assert sum == 4
  end

  test "should calc p1 result" do
    lines =
      File.stream!("./test/day_seven/input")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    map = Bags.parse_lines(lines)

    sum =
      Map.keys(map)
      |> Enum.map(fn k -> if Bags.walk_path(map, k, "shiny gold"), do: 1, else: 0 end)
      |> Enum.sum()

    assert sum == 337
  end

  test "should calc p2 @data" do
    lines = @data |> String.split("\n") |> Enum.map(&String.trim/1)

    map = Bags.parse_lines(lines)

    sum = Bags.count_bags(map, "shiny gold")

    assert sum == 32
  end

  test "should calc p2 with p2 data" do
    data = "shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags."
    lines = data |> String.split("\n") |> Enum.map(&String.trim/1)

    map = Bags.parse_lines(lines)

    sum = Bags.count_bags(map, "shiny gold")

    assert sum == 126
  end

  test "should calc p2 with input" do
    lines =
      File.stream!("./test/day_seven/input")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    map = Bags.parse_lines(lines)

    sum = Bags.count_bags(map, "shiny gold")

    assert sum == 50100
  end
end
