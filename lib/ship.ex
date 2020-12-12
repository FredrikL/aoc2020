defmodule Ship do
  def move(ship, instruction) do
    i = String.slice(instruction, 0..0)

    value = String.slice(instruction, 1..-1) |> String.to_integer()

    case i do
      "N" ->
        Map.update!(ship, :north, &(&1 + value))

      "S" ->
        Map.update!(ship, :north, &(&1 - value))

      "E" ->
        Map.update!(ship, :east, &(&1 + value))

      "W" ->
        Map.update!(ship, :east, &(&1 - value))

      "R" ->
        new_facing = change_facing(ship.facing, :right, value)
        Map.put(ship, :facing, new_facing)

      "L" ->
        new_facing = change_facing(ship.facing, :left, value)
        Map.put(ship, :facing, new_facing)

      "F" ->
        move_forward(ship, value)
    end
  end

  defp move_forward(ship, value) do
    case ship.facing do
      :east ->
        Map.update!(ship, :east, &(&1 + value))

      :south ->
        Map.update!(ship, :north, &(&1 - value))

      :west ->
        Map.update!(ship, :east, &(&1 - value))

      :north ->
        Map.update!(ship, :north, &(&1 + value))
    end
  end

  defp change_facing(current, direction, amount) do
    directions = [:east, :south, :west, :north]
    steps = round(amount / 90)
    index = Enum.find_index(directions, &(&1 == current))
    new_index = if direction == :right, do: rem(index + steps, 4), else: rem(index - steps, 4)
    Enum.at(directions, new_index)
  end

  def move_p2({{x, y} = boat, {vx, vy}}, instruction) do
    i = String.slice(instruction, 0..0)
    value = String.slice(instruction, 1..-1) |> String.to_integer()

    case i do
      "N" ->
        {boat, {vx, vy + value}}

      "S" ->
        {boat, {vx, vy - value}}

      "E" ->
        {boat, {vx + value, vy}}

      "W" ->
        {boat, {vx - value, vy}}

      "R" ->
        {boat, rotate_right({vx, vy}, value)}

      "L" ->
        {boat, rotate_left({vx, vy}, value)}

      "F" ->
        {{x + vx * value, y + vy * value}, {vx, vy}}
    end
  end

  def rotate_left(waypoint, 0), do: waypoint
  def rotate_left({vx, vy}, degrees), do: rotate_left({-vy, vx}, degrees - 90)

  def rotate_right(waypoint, 0), do: waypoint
  def rotate_right({vx, vy}, degrees), do: rotate_right({vy, -vx}, degrees - 90)
end
