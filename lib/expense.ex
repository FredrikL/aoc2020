defmodule Expense do
  require Logger

  def get_entries(input) do
    input
    |> Enum.map(fn a ->
      b = test(a, input)

      if b != nil do
        {a, b}
      else
        false
      end
    end)
    |> Enum.filter(fn a -> a end)
    |> List.first()
  end

  def get_3_entries(input) do
    input
    |> Enum.map(fn a ->
      b = xxx(a, input)

      if b != nil do
        b
      else
        false
      end
    end)
    |> Enum.filter(fn a -> a end)
    |> List.first()
  end

  defp xxx(a, input) do
    input
    |> Enum.map(fn b ->
      c = test(a, b, input)

      if c != nil do
        # Logger.info("Not nil")
        {a, b, c}
      else
        false
      end
    end)
    |> Enum.filter(fn a -> a end)
    |> List.first()
  end

  def get_sum(a, b) do
    a * b
  end

  defp test(a, input) do
    input |> Enum.find(fn b -> is_2020(a, b) end)
  end

  defp test(a, b, input) do
    input |> Enum.find(fn c -> is_2020(a, b, c) end)
  end

  defp is_2020(a, b) do
    a + b == 2020
  end

  defp is_2020(a, b, c) do
    #    Logger.info("#{a} #{b} #{c}")
    a + b + c == 2020
  end
end
