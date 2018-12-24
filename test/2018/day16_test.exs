defmodule AoC.Year2018.Day16Test do
  use ExUnit.Case

  import AoC.Year2018.Day16

  @moduletag finished: true

  test "three_or_more" do
    input = """
    Before: [3, 2, 1, 1]
    9 2 1 2
    After:  [3, 2, 2, 1]
    """

    assert 1 == three_or_more(input)
  end
end
