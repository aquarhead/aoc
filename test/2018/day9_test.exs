defmodule AoC.Year2018.Day9Test do
  use ExUnit.Case

  import AoC.Year2018.Day9

  test "high_score" do
    assert 0 == high_score(9, 10)
    assert 32 == high_score(9, 25)
    assert 8317 == high_score(10, 1618)
    assert 146_373 == high_score(13, 7999)
    assert 2764 == high_score(17, 1104)
    assert 54718 == high_score(21, 6111)
    assert 37305 == high_score(30, 5807)
  end
end
