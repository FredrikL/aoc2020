defmodule Day14.Day14Test do
  use ExUnit.Case
  use Bitwise

  test "Should parse mask" do
    mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
    parsed = parse_mask(mask)

    assert parsed == %{34 => "0", 29 => "1"}
  end

  test "Should apply mask to value" do
    mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
    parsed = parse_mask(mask)

    result = apply_mask(11, parsed)
    assert result == 73

    assert 101 == apply_mask(101, parsed)
    assert 64 == apply_mask(0, parsed)
  end

  test "Run simple program" do
    prog = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"

    {_, mem} =
      prog
      |> String.split("\n")
      |> Enum.reduce({"", %{}}, fn instr, {mask, mem} ->
        run_line(mask, mem, instr)
      end)

    sum = mem |> Map.to_list() |> Enum.map(fn {_, v} -> v end) |> Enum.sum()

    assert sum == 165
  end

  test "Run puzzle program" do
    prog = input = File.read!("./test/day_14/input")

    {_, mem} =
      prog
      |> String.split("\n", trim: true)
      |> Enum.reduce({"", %{}}, fn instr, {mask, mem} ->
        run_line(mask, mem, instr)
      end)

    sum = mem |> Map.to_list() |> Enum.map(fn {_, v} -> v end) |> Enum.sum()

    assert sum == 8_566_770_985_168
  end

  defp run_line(mask, mem, line) do
    [op, data] = String.split(line, " = ")

    case op do
      "mask" ->
        {parse_mask(data), mem}

      _ ->
        pos = String.slice(op, 4..-2)
        {mask, update_mem(mem, mask, pos, data)}
    end
  end

  defp update_mem(mem, mask, pos, value) do
    v = String.to_integer(value)
    new = apply_mask(v, mask)
    Map.put(mem, pos, new)
  end

  defp parse_mask(mask) do
    mask
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {v, _i} -> v != "X" end)
    |> Enum.reduce(%{}, fn {v, i}, acc -> Map.put(acc, i, v) end)
  end

  defp apply_mask(value, mask) do
    v = String.pad_leading(Integer.to_string(value, 2), 36, "0")

    v
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {v, i} ->
      if(Map.has_key?(mask, i)) do
        mask[i]
      else
        v
      end
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end
end
