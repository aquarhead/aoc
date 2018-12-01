defmodule AoC.Year2018.Day1Test do
  use ExUnit.Case

  import AoC.Year2018.Day1

  test "freq" do
    assert 3 == freq("+1, -2, +3, +1")
    assert 3 == freq("+1, +1, +1")
    assert 0 == freq("+1, +1, -2")
    assert -6 == freq("-1, -2, -3")
  end
end
