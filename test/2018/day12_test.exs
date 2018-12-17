defmodule AoC.Year2018.Day12Test do
  use ExUnit.Case

  import AoC.Year2018.Day12
  @moduletag finished: true

  test "sum" do
    init_state = "#..#.#..##......###...###"

    rules = """
    ...## => #
    ..#.. => #
    .#... => #
    .#.#. => #
    .#.## => #
    .##.. => #
    .#### => #
    #.#.# => #
    #.### => #
    ##.#. => #
    ##.## => #
    ###.. => #
    ###.# => #
    ####. => #
    """

    assert 325 == sum(init_state, rules)
  end
end
