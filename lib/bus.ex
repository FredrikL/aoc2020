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

  def find_first(time, timetable) do
    match = timetable |> Enum.filter(fn bus -> rem(time, bus) == 0 end)

    if(length(match) > 0) do
      {time, hd(match)}
    else
      find_first(time + 1, timetable)
    end
  end
end
