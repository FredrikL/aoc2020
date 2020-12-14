defmodule Day13.Day13Test do
  use ExUnit.Case

  test "should parse timetable" do
    result = Bus.get_times("7,13,x,x,59,x,31,19")
    assert result == [7, 13, 59, 31, 19]
  end

  test "should find first" do
    result = Bus.find_first(939, [7, 13, 59, 31, 19])

    assert result == {944, 59}
    {depart, bus} = result
    assert (depart - 939) * bus == 295
  end

  test "should find first in puzzle input" do
    times =
      Bus.get_times(
        "41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,431,x,x,x,x,x,x,x,23,x,x,x,x,13,x,x,x,17,x,19,x,x,x,x,x,x,x,x,x,x,x,863,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,29"
      )

    result = Bus.find_first(1_001_938, times)

    {depart, bus} = result
    assert (depart - 1_001_938) * bus == 4315
  end

  test "get timestamp offsets" do
    result = Bus.get_offsets("7,13,x,x,59,x,31,19")

    assert result == [{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}]
  end

  test "slow approche" do
    table = Bus.get_offsets("17,x,13,19")
    time = Bus.find_first_cons(table)
    assert time == 3417

    # table = Bus.get_offsets("67,7,59,61")
    # time = Bus.find_first_cons(table)
    # assert time == 754_018

    # table = Bus.get_offsets("67,x,7,59,61")
    # time = Bus.find_first_cons(table)
    # assert time == 779_210

    # table = Bus.get_offsets("67,7,x,59,61")
    # time = Bus.find_first_cons(table)
    # assert time == 1_261_476

    # table = Bus.get_offsets("1789,37,47,1889")
    # time = Bus.find_first_cons(table)
    # assert time == 1_202_161_486
  end
end
