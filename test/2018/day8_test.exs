defmodule AoC.Year2018.Day8Test do
  use ExUnit.Case

  import AoC.Year2018.Day8

  test "sum" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    assert 138 == sum(input)
  end
end
