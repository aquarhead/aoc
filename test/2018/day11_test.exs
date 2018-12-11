defmodule AoC.Year2018.Day11Test do
  use ExUnit.Case

  import AoC.Year2018.Day11

  test "largest" do
    assert {33, 45} == largest(18)
    assert {21, 61} == largest(42)
  end
end
