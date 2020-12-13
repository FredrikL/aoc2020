defmodule Day13.Day13Test do
  use ExUnit.Case

  test "should parse timetable" do
    result = Bus.get_times("7,13,x,x,59,x,31,19")
    assert result == [7, 13, 59, 31, 19]
  end

  test "should find first" do
    result = Bus.find_first(939, [7, 13, 59, 31, 19])
    # IO.inspect(result)
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
end
