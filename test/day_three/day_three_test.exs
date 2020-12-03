defmodule DayThree.DayThreeTest do
  use ExUnit.Case

  require Logger

  @testinput "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"

  test "should parse input to map" do
    parsed = Trajectory.parse_input_str(@testinput)

    assert parsed[0][0] == "."
    assert parsed[1][0] == "#"
    assert parsed[10][10] == "#"
    assert length(Map.keys(parsed)) == 11
  end

  test "should travers and count #" do
    parsed = Trajectory.parse_input_str(@testinput)
    no = Trajectory.traverse(parsed, {0, 0}, {3, 1})

    assert no == 7
  end

  # @tag :skip
  test "should handle day 3 input file" do
    file =
      File.stream!("./test/day_three/input_day_3.txt")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    parsed = Trajectory.parse_input(file)
    assert length(Map.keys(parsed)) == 323
    no = Trajectory.traverse(parsed, {0, 0}, {3, 1})

    assert no == 223
  end

  test "should travers and count p2" do
    parsed = Trajectory.parse_input_str(@testinput)

    nums = [
      Trajectory.traverse(parsed, {0, 0}, {1, 1}),
      Trajectory.traverse(parsed, {0, 0}, {3, 1}),
      Trajectory.traverse(parsed, {0, 0}, {5, 1}),
      Trajectory.traverse(parsed, {0, 0}, {7, 1}),
      Trajectory.traverse(parsed, {0, 0}, {1, 2})
    ]

    assert nums == [2, 7, 3, 4, 2]
    sum = Enum.reduce(nums, 1, fn v, acc -> v * acc end)
    assert sum == 336
  end

  test "should travers and count p2 with full data" do
    file =
      File.stream!("./test/day_three/input_day_3.txt")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    parsed = Trajectory.parse_input(file)

    nums = [
      Trajectory.traverse(parsed, {0, 0}, {1, 1}),
      Trajectory.traverse(parsed, {0, 0}, {3, 1}),
      Trajectory.traverse(parsed, {0, 0}, {5, 1}),
      Trajectory.traverse(parsed, {0, 0}, {7, 1}),
      Trajectory.traverse(parsed, {0, 0}, {1, 2})
    ]

    sum = Enum.reduce(nums, 1, fn v, acc -> v * acc end)
    assert sum == 3_517_401_300
  end
end
