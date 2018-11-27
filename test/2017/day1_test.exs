defmodule AoC.Year2017.Day1Test do
  use ExUnit.Case

  alias AoC.Year2017.Day1

  test "sum" do
    assert 3 == Day1.sum("1122")
    assert 4 == Day1.sum("1111")
    assert 0 == Day1.sum("1234")
    assert 9 == Day1.sum("91212129")
  end
end
