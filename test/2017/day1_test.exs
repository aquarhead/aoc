defmodule AoC.Year2017.Day1Test do
  use ExUnit.Case
  @moduletag finished: true

  alias AoC.Year2017.Day1

  test "sum" do
    assert 3 == Day1.sum("1122")
    assert 4 == Day1.sum("1111")
    assert 0 == Day1.sum("1234")
    assert 9 == Day1.sum("91212129")
  end

  test "sum2" do
    assert 6 == Day1.sum2("1212")
    assert 0 == Day1.sum2("1221")
    assert 4 == Day1.sum2("123425")
    assert 12 == Day1.sum2("123123")
    assert 4 == Day1.sum2("12131415")
  end
end
