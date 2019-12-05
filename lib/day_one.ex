defmodule DayOne do
  def calc(weight) do
    floor(weight / 3) - 2
  end

  def parse_file() do
    File.stream!("./test/day_one_input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      {val, _x} = Integer.parse(line)
      val
    end)
    |> Enum.to_list()
  end

  def calc_req do
    parse_file()
    |> Enum.map(&calc/1)
    |> Enum.sum()
  end

  def weight_with_fuel(weight) do
    req = calc(weight)

    if req > 0 do
      req + weight_with_fuel(req)
    else
      0
    end
  end

  def calc_req_fuel do
    parse_file()
    |> Enum.map(&weight_with_fuel/1)
    |> Enum.sum()
  end
end
