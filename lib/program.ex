defmodule Program do
  def load(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {v, i} ->
      [inst, offset] = String.split(v, " ", trim: true)
      {v, _} = Integer.parse(offset)
      %{i => {inst, v}}
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  def run(state) do
    if state.instr[state.pc] != nil do
      state = step(state)

      if(state[:exit]) do
        state
      else
        run(state)
      end
    else
      state |> Map.put(:terminated, true)
    end
  end

  def step(state) do
    instr = state.instr[state.pc]

    {newpc, newacc} =
      case instr do
        {"nop", _} ->
          {state.pc + 1, state.acc}

        {"acc", val} ->
          {state.pc + 1, state.acc + val}

        {"jmp", val} ->
          {state.pc + val, state.acc}
      end

    if(newpc in state.history) do
      state |> Map.put(:exit, true)
    else
      state
      |> Map.put(:pc, newpc)
      |> Map.put(:acc, newacc)
      |> Map.put(:history, MapSet.put(state.history, newpc))
    end
  end
end
