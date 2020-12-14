defmodule Bus do
  def get_times(input) do
    input
    |> String.split(",")
    |> Enum.filter(&(&1 != "x"))
    |> Enum.map(fn v ->
      {i, _} = Integer.parse(v)
      i
    end)
  end

  @spec find_first(any, any) :: {any, any}
  def find_first(time, timetable) do
    match = timetable |> Enum.filter(fn bus -> rem(time, bus) == 0 end)

    if(length(match) > 0) do
      {time, hd(match)}
    else
      find_first(time + 1, timetable)
    end
  end

  def get_offsets(input) do
    input
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.filter(fn {v, _i} ->
      v != "x"
    end)
    |> Enum.map(fn {v, idx} ->
      {i, _} = Integer.parse(v)
      {i, idx}
    end)
  end

  def find_first_cons(table, start \\ 0) do
    # largest = table |> Enum.reduce(0, fn {v, _}, acc -> if v > acc, do: v, else: acc end)
    # IO.inspect(largest)
    gen = Stream.iterate(start, &(&1 + 1))

    {:ok, result} =
      Task.async_stream(gen, fn v ->
        # IO.puts(v)

        if matches_table(v, table) do
          v
        else
          false
        end
      end)
      |> Enum.find(fn {:ok, v} -> v != false end)

    result
  end

  defp matches_table(time, table) do
    #    IO.puts(time)

    table
    |> Enum.map(fn {bus, offset} ->
      rem(time + offset, bus) == 0
    end)
    |> Enum.all?(& &1)
  end
end
