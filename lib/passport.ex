defmodule Passport do
  def parse_file(input) do
    input |> String.split("\n\n")
  end

  def parse_passport(input) do
    input
    |> String.split()
    |> Enum.map(fn v ->
      [k, v] = String.split(v, ":")
      %{k => v}
    end)
    |> Enum.reduce(%{}, fn v, acc -> Map.merge(v, acc) end)
  end

  def is_valid?(passport) do
    required = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
    keys = Map.keys(passport)

    result = MapSet.difference(MapSet.new(required), MapSet.new(keys)) |> MapSet.to_list()

    result == [] || result == ["cid"]
  end

  def is_present?(passport) do
    passport["pid"] |> String.match?(~r/^\d{9}$/) and
      Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], passport["ecl"]) and
      passport["hcl"] |> String.match?(~r/^#[0-9a-f]{6}$/) and
      year_valid?(passport["byr"], 1920, 2002) and
      year_valid?(passport["iyr"], 2010, 2020) and
      year_valid?(passport["eyr"], 2020, 2030) and
      height_valid?(passport["hgt"])
  end

  defp year_valid?(value, low, high) do
    case Integer.parse(value) do
      :error ->
        false

      {value, _} ->
        low <= value && value <= high
    end
  end

  defp height_valid?(value) do
    if(String.ends_with?(value, "in")) do
      {h, _} = String.replace(value, "in", "") |> Integer.parse()
      59 <= h and h <= 76
    else
      {h, _} = String.replace(value, "cm", "") |> Integer.parse()
      150 <= h and h <= 193
    end
  end
end
