defmodule AoC.Year2017.Day2Test do
  use ExUnit.Case

  alias AoC.Year2017.Day2

  @input """
  5 1 9 5
  7 5 3
  2 4 6 8
  """

  test "checksum" do
    assert 18 == Day2.checksum(@input)
  end

  # @input """
  # 5 9 2 8
  # 9 4 7 3
  # 3 8 6 5
  # """

  test "checksum2" do
    # assert 9 == Day2.checksum2(@input)
  end
end
