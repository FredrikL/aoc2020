defmodule DayOneTest do
  use ExUnit.Case

  test "12" do
    assert DayOne.calc(12) == 2
  end

  test "14" do
    assert DayOne.calc(14) == 2
  end

  test "1969" do
    assert DayOne.calc(1969) == 654
  end

  test "100756" do
    assert DayOne.calc(100_756) == 33583
  end

  test "parse file" do
    assert DayOne.parse_file() != []
  end

  test "get sum from file" do
    result = DayOne.calc_req()
    IO.puts(result)

    assert result != 0
  end
end
