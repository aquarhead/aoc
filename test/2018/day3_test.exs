defmodule AoC.Year2018.Day3Test do
  use ExUnit.Case
  import AoC.Year2018.Day3

  test "overlap" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert 4 == overlap(input)
  end
end
