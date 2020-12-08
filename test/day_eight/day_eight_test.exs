defmodule DayEight.DayEightTest do
  use ExUnit.Case

  @test_data "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"

  test "should parse single line instruction" do
    loaded = Program.load("nop +0")
    expected = %{0 => {"nop", 0}}

    assert loaded == expected
  end

  test "should parse 2 lines of instructions" do
    loaded = Program.load("nop +0
      acc +1")
    expected = %{0 => {"nop", 0}, 1 => {"acc", 1}}

    assert loaded == expected
  end

  test "should parse instructions" do
    loaded = Program.load(@test_data)

    expected = %{
      0 => {"nop", 0},
      1 => {"acc", 1},
      2 => {"jmp", 4},
      3 => {"acc", 3},
      4 => {"jmp", -3},
      5 => {"acc", -99},
      6 => {"acc", 1},
      7 => {"jmp", -4},
      8 => {"acc", 6}
    }

    assert loaded == expected
  end

  test "should step program" do
    instructions = Program.load(@test_data)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    state = Program.step(state)

    assert state.pc == 1
  end

  test "should step twice program" do
    instructions = Program.load(@test_data)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    state = Program.step(state) |> Program.step()

    assert state.pc == 2
    assert state.acc == 1
  end

  test "should step three times" do
    instructions = Program.load(@test_data)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    state = state |> Program.step() |> Program.step() |> Program.step()

    assert state.pc == 6
    assert state.acc == 1
  end

  test "should run program until we hit same instruction" do
    instructions = Program.load(@test_data)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    result = Program.run(state)

    assert result.acc == 5
  end

  test "should run p1 input" do
    {:ok, input} = File.read("./test/day_eight/input")
    instructions = Program.load(input)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    result = Program.run(state)

    assert result.acc == 1675
  end

  test "should run program to end" do
    input = "nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    nop -4
    acc +6"

    instructions = Program.load(input)
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    result = Program.run(state)

    assert result.acc == 8
    assert result.terminated
  end

  test "should modify program until we run to terminate" do
    {:ok, input} = File.read("./test/day_eight/input")
    instructions = Program.load(input)

    state =
      Map.keys(instructions)
      |> Enum.map(fn k ->
        ins = instructions[k]

        case ins do
          {"nop", 0} ->
            false

          {"nop", val} ->
            updated = Map.put(instructions, k, {"jmp", val})
            result = run(updated)

            if(Map.has_key?(result, :terminated)) do
              result
            else
              false
            end

          {"jmp", 0} ->
            false

          {"jmp", val} ->
            updated = Map.put(instructions, k, {"nop", val})
            result = run(updated)

            if(Map.has_key?(result, :terminated)) do
              result
            else
              false
            end

          {_, _} ->
            false
        end
      end)
      |> Enum.filter(fn v -> v != false end)
      |> Enum.at(0)

    assert state.acc == 1532
  end

  defp run(instructions) do
    state = %{instr: instructions, acc: 0, pc: 0, history: MapSet.new()}

    Program.run(state)
  end
end
