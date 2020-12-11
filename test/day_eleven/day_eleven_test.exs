defmodule DayEleven.DayElevenTest do
  use ExUnit.Case

  @example "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"

  test "step board" do
    board = Seating.parse(@example)

    {_board, _fixed_state, count} = Seating.generation(board, false)

    assert count == 37
  end

  test "count taken" do
    board = Seating.parse(@example)

    result = Seating.count_taken(1, 1, board)

    assert result == 0
  end

  @tag :skip
  test "run input" do
    input = File.read!("./test/day_eleven/input")
    board = Seating.parse(input)
    {_board, _fixed_state, count} = Seating.generation(board, false)

    assert count == 2368
  end

  test "step board p2" do
    board = Seating.parse(@example)

    {_board, _fixed_state, count} = Seating.generation(board, true)

    assert count == 26
  end

  @tag :skip
  test "run input p2" do
    input = File.read!("./test/day_eleven/input")
    board = Seating.parse(input)
    {_board, _fixed_state, count} = Seating.generation(board, true)

    assert count == 2368
  end
end
