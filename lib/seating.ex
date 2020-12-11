defmodule Seating do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {r, i} ->
      %{i => row_to_map(r)}
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  defp row_to_map(row) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {seat, i} ->
      %{i => seat |> seat_to_atom}
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  defp seat_to_atom(seat) do
    case seat do
      "L" -> :free
      "." -> :floor
      "#" -> :taken
    end
  end

  def generation(board, p2) do
    {new, fixed, count} = step_board(board, p2)

    if(fixed) do
      {new, true, count}
    else
      generation(new, p2)
    end
  end

  def step_board(board, p2) do
    rows = length(Map.keys(board)) - 1
    columns = length(Map.keys(board[0])) - 1

    new =
      for x <- 0..rows,
          y <- 0..columns,
          do: if(p2, do: new_state_p2(x, y, board), else: new_state(x, y, board))

    taken_count =
      new |> Enum.map(fn {_, _, state} -> if state == :taken, do: 1, else: 0 end) |> Enum.sum()

    new_board =
      Enum.reduce(new, board, fn {x, y, state}, acc ->
        acc |> put_in([x, y], state)
      end)

    {new_board, board == new_board, taken_count}
  end

  def new_state(x, y, board) do
    current = get_in(board, [x, y])
    taken = count_taken(x, y, board)

    state =
      case current do
        :floor ->
          :floor

        :free ->
          if taken == 0, do: :taken, else: :free

        :taken ->
          if taken >= 4, do: :free, else: :taken
      end

    {x, y, state}
  end

  def count_taken(x, y, board) do
    # count number of :taken round x
    for(
      i <- [x - 1, x, x + 1],
      j <- [y - 1, y, y + 1],
      !(i == x and j == y),
      do: get_in(board, [i, j])
    )
    |> Enum.filter(&(&1 == :taken))
    |> Enum.count()
  end

  def new_state_p2(x, y, board) do
    current = get_in(board, [x, y])
    taken = count_line_of_sight(x, y, board)

    state =
      case current do
        :floor ->
          :floor

        :free ->
          if taken == 0, do: :taken, else: :free

        :taken ->
          if taken >= 5, do: :free, else: :taken
      end

    {x, y, state}
  end

  def count_line_of_sight(x, y, board) do
    directions = for i <- -1..1, j <- -1..1, !(i == 0 and j == 0), do: {i, j}

    directions
    |> Enum.map(fn dir -> check_line_of_sight({x, y}, dir, board) end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def check_line_of_sight({x, y}, {dx, dy} = direction, board) do
    pos_x = x + dx
    pos_y = y + dy
    check = get_in(board, [pos_x, pos_y])

    case check do
      :taken -> true
      :free -> false
      nil -> false
      :floor -> check_line_of_sight({pos_x, pos_y}, direction, board)
    end
  end
end
