defmodule AoC.Year2018.Day15Test do
  use ExUnit.Case

  import AoC.Year2018.Day15

  @moduletag finished: true

  test "combat" do
    input1 = """
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """

    assert 27730 = combat_outcome(input1)

    input2 = """
    #######
    #G..#E#
    #E#E.E#
    #G.##.#
    #...#E#
    #...E.#
    #######
    """

    assert 36334 = combat_outcome(input2)

    input3 = """
    #######
    #E..EG#
    #.#G.E#
    #E.##E#
    #G..#.#
    #..E#.#
    #######
    """

    assert 39514 = combat_outcome(input3)

    input4 = """
    #######
    #E.G#.#
    #.#G..#
    #G.#.G#
    #G..#.#
    #...E.#
    #######
    """

    assert 27755 = combat_outcome(input4)

    input5 = """
    #######
    #.E...#
    #.#..G#
    #.###.#
    #E#G#G#
    #...#G#
    #######
    """

    assert 28944 = combat_outcome(input5)

    input6 = """
    #########
    #G......#
    #.E.#...#
    #..##..G#
    #...##..#
    #...#...#
    #.G...G.#
    #.....G.#
    #########
    """

    assert 18740 = combat_outcome(input6)
  end

  test "help_elves" do
    input1 = """
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """

    assert 4988 = help_elves(input1)

    input2 = """
    #######
    #E..EG#
    #.#G.E#
    #E.##E#
    #G..#.#
    #..E#.#
    #######
    """

    assert 31284 = help_elves(input2)
  end
end
