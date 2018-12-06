defmodule AoC.Year2018.Day6Test do
  use ExUnit.Case

  import AoC.Year2018.Day6

  test "largest" do
    input1 = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert 17 == largest(input1)

    # a    c
    #
    #     Eeeeeee
    #
    # b    d

    input2 = """
    0, 0
    4, 0
    0, 4
    4, 4
    2, 3
    """

    assert 0 == largest(input2)
  end

  test "safe" do
    input1 = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert 16 == safe(input1, 32)
  end
end
