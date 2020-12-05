defmodule DayFive.DayFiveTest do
  use ExUnit.Case

  test "should parse row" do
    input = "FBFBBFF"
    expected = 44

    [result] = Boarding.get_row(input)

    assert result == expected
  end

  test "should parse column" do
    input = "RLR"
    expected = 5

    [result] = Boarding.get_column(input)

    assert result == expected
  end

  test "should calculate card" do
    input = "FBFBBFFRLR"
    expected = 357

    result = Boarding.calc_card(input)

    assert result == expected
  end

  test "should handle testdata" do
    assert Boarding.calc_card("BFFFBBFRRR") == 567
    assert Boarding.calc_card("FFFBBBFRRR") == 119
    assert Boarding.calc_card("BBFFBBFRLL") == 820
  end

  test "should parse input" do
    file =
      File.stream!("./test/day_five/input")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    rows = file |> Enum.map(&Boarding.calc_card/1)

    higest =
      rows
      |> Enum.reduce(0, fn v, acc ->
        if v > acc, do: v, else: acc
      end)

    assert higest == 883
  end

  test "should find seat input" do
    file =
      File.stream!("./test/day_five/input")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    rows = file |> Enum.map(&Boarding.calc_card/1) |> Enum.to_list()
    all = 85..883 |> Enum.to_list()

    [missing] = all -- rows

    assert missing == 532
  end
end
