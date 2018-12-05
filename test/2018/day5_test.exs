defmodule AoC.Year2018.Day5Test do
  use ExUnit.Case

  import AoC.Year2018.Day5

  test "react" do
    assert 0 == react("abBA")
    assert 10 == react("dabAcCaCBAcCcaDA")
  end

  test "shortest" do
    assert 4 == shortest("dabAcCaCBAcCcaDA")
  end
end
