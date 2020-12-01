defmodule DayOne.Part1 do
  use ExUnit.Case

  require Logger

  test "get entris from test input" do
    assert Expense.get_entries([1721, 979, 366, 299, 675, 1456]) == {1721, 299}
  end

  test "should sum" do
    assert Expense.get_sum(1721, 299) == 514_579
  end

  defp get_file_content() do
    File.stream!("./test/day_one/day_one_part_1_input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      {val, _x} = Integer.parse(line)
      val
    end)
    |> Enum.to_list()
  end

  test "should handle puzzle input part 1" do
    input = get_file_content()
    {a, b} = Expense.get_entries(input)

    assert a + b == 2020

    assert a * b == 972_576
  end

  test "get 3 entris from test input" do
    assert Expense.get_3_entries([1721, 979, 366, 299, 675, 1456]) == {979, 366, 675}
  end

  test "should handle puzzle input part 2" do
    input = get_file_content()
    {a, b, c} = Expense.get_3_entries(input)

    assert a + b + c == 2020

    assert a * b * c == 199_300_880
  end
end
