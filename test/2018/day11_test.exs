defmodule AoC.Year2018.Day11Test do
  use ExUnit.Case

  import AoC.Year2018.Day11

  @tag finished: true
  test "largest" do
    assert "33,45" == largest(18)
    assert "21,61" == largest(42)
  end

  # test "largest_any" do
  #   assert "90,269,16" == largest_any(18)
  # end
end
