defmodule Password do
  def split_input(input) do
    [rules, password] = String.split(input, ": ")
    [m, char] = String.split(rules, " ")

    [min, max] =
      String.split(m, "-") |> Enum.map(&Integer.parse/1) |> Enum.map(fn {v, _} -> v end)

    {[char: char, min: min, max: max], password}
  end

  def is_valid?(rules, password) do
    matching_count =
      password
      |> String.graphemes()
      |> Enum.reduce(
        0,
        fn v, acc ->
          if(v == rules[:char]) do
            acc + 1
          else
            acc
          end
        end
      )

    rules[:min] <= matching_count and matching_count <= rules[:max]
  end

  def is_valid_p2?(rules, password) do
    low = String.at(password, rules[:min] - 1)
    high = String.at(password, rules[:max] - 1)

    (low == rules[:char] and high != rules[:char]) ||
      (high == rules[:char] and low != rules[:char])
  end
end
