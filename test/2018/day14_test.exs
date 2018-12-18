defmodule AoC.Year2018.Day14Test do
  use ExUnit.Case

  import AoC.Year2018.Day14

  test "ten_scores" do
    assert "5158916779" == ten_scores(9)
    assert "0124515891" == ten_scores(5)
    assert "9251071085" == ten_scores(18)
    assert "5941429882" == ten_scores(2018)
  end
end
