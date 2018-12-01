defmodule AoC.Year2018.Day1Test do
  use ExUnit.Case

  import AoC.Year2018.Day1

  test "freq" do
    assert 3 == freq("+1, -2, +3, +1")
    assert 3 == freq("+1, +1, +1")
    assert 0 == freq("+1, +1, -2")
    assert -6 == freq("-1, -2, -3")
  end

  test "freq2" do
    assert 2 == freq2("+1, -2, +3, +1")
    assert 0 == freq2("+1, -1")
    assert 10 == freq2("+3, +3, +4, -2, -4")
    assert 5 == freq2("-6, +3, +8, +5, -6")
    assert 14 == freq2("+7, +7, -2, -7, -4")
  end
end
