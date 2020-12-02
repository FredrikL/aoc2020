defmodule DayTwo.DayTwoTest do
  use ExUnit.Case

  require Logger

  test "split" do
    {rules, password} = Password.split_input("1-3 a: abcde")
    assert password == "abcde"
    assert rules == [char: "a", min: 1, max: 3]
  end

  test "should handle basic rules 1" do
    assert valid?("1-3 a: abcde") == true
  end

  test "should handle basic rules 2" do
    assert valid?("1-3 b: cdefg") == false
  end

  test "should handle basic rules 3" do
    assert valid?("2-9 c: ccccccccc") == true
  end

  test "should handle basic rules 1 p2" do
    assert validp2?("1-3 a: abcde") == true
  end

  test "should handle basic rules 2 p2" do
    assert validp2?("1-3 b: cdefg") == false
  end

  test "should handle basic rules 3 p2 " do
    assert validp2?("2-9 c: ccccccccc") == false
  end

  test "should validate file" do
    content = get_file_content()

    valid_count =
      content
      |> Enum.reduce(0, fn v, acc ->
        if(valid?(v)) do
          acc + 1
        else
          acc
        end
      end)

    assert valid_count == 477
  end

  test "should validate file p2" do
    content = get_file_content()

    valid_count =
      content
      |> Enum.reduce(0, fn v, acc ->
        if(validp2?(v)) do
          acc + 1
        else
          acc
        end
      end)

    assert valid_count == 686
  end

  defp get_file_content() do
    File.stream!("./test/day_two/day_2_input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  defp valid?(row) do
    {rules, password} = Password.split_input(row)
    Password.is_valid?(rules, password)
  end

  defp validp2?(row) do
    {rules, password} = Password.split_input(row)
    Password.is_valid_p2?(rules, password)
  end
end
