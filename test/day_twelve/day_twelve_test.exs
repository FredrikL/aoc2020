defmodule DayTwelve.DayTwelveTest do
  use ExUnit.Case

  test "shold handle basic directions" do
    ship = %{east: 0, north: 0, facing: :east}
    ship = Ship.move(ship, "N3")
    assert ship.north == 3
    ship = Ship.move(ship, "S1")
    assert ship.north == 2
    ship = Ship.move(ship, "E3")
    assert ship.east == 3
    ship = Ship.move(ship, "W2")
    assert ship.east == 1

    ship = Ship.move(ship, "R90")
    assert ship.facing == :south
    ship = Ship.move(ship, "L90")
    assert ship.facing == :east
    ship = Ship.move(ship, "L90")
    assert ship.facing == :north
    ship = Ship.move(ship, "L180")
    assert ship.facing == :south
    ship = Ship.move(ship, "L90")
    assert ship.facing == :east

    ship = Ship.move(ship, "F10")
    assert ship.east == 11
  end

  test "should move as example" do
    input = "F10
    N3
    F7
    R90
    F11"

    ship = %{east: 0, north: 0, facing: :east}

    result =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(ship, fn i, ship -> Ship.move(ship, String.trim(i)) end)

    assert result.east == 17
    assert result.north == -8
    assert abs(result.east) + abs(result.north) == 25
  end

  test "calc p1 with test input " do
    input = File.read!("./test/day_twelve/input")
    ship = %{east: 0, north: 0, facing: :east}

    result =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(ship, fn i, ship -> Ship.move(ship, String.trim(i)) end)

    assert abs(result.east) + abs(result.north) == 904
  end

  test "p2 example" do
    # ship = %{east: 0, north: 0, facing: :east, wp_east: 10, wp_north: 1}
    ship = {{0, 0}, {10, 1}}

    ship = Ship.move_p2(ship, "F10")

    ship = Ship.move_p2(ship, "N3")

    ship = Ship.move_p2(ship, "F7")

    ship = Ship.move_p2(ship, "R90")

    ship = Ship.move_p2(ship, "F11")
    {{x, y}, _} = ship

    assert x == 214
    assert y == -72
  end

  test "should move as p2 example" do
    input = "F10
    N3
    F7
    R90
    F11"

    ship = {{0, 0}, {10, 1}}

    result =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(ship, fn i, ship -> Ship.move_p2(ship, String.trim(i)) end)

    {{x, y}, _} = result

    assert x == 214
    assert y == -72
    assert abs(x) + abs(y) == 286
  end

  test "calc p2 with test input " do
    input = File.read!("./test/day_twelve/input")
    ship = {{0, 0}, {10, 1}}

    result =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(ship, fn i, ship -> Ship.move_p2(ship, String.trim(i)) end)

    {{x, y}, _} = result

    assert abs(x) + abs(y) == 18747
  end
end
