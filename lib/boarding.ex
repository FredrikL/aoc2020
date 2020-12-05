defmodule Boarding do
  def calc_card(input) do
    [row] = String.slice(input, 0, 7) |> get_row()
    [column] = String.slice(input, 7, 3) |> get_column()
    row * 8 + column
  end

  def get_row(input) do
    get_row(input |> String.graphemes(), 0..127 |> Enum.to_list())
  end

  defp get_row(list, range) do
    [h | t] = list
    len = round(length(range) / 2)
    x = Enum.chunk_every(range, len, len)

    [rl, rh] = x

    val =
      case h do
        "F" ->
          rl

        "B" ->
          rh
      end

    if(t == []) do
      val
    else
      get_row(t, val)
    end
  end

  def get_column(input) do
    get_column(
      input |> String.graphemes(),
      0..7 |> Enum.to_list()
    )
  end

  defp get_column(list, range) do
    [h | t] = list
    len = round(length(range) / 2)
    x = Enum.chunk_every(range, len, len)

    [rl, rh] = x

    val =
      case h do
        "L" ->
          rl

        "R" ->
          rh
      end

    if(t == []) do
      val
    else
      get_column(t, val)
    end
  end
end
