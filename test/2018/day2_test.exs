defmodule AoC.Year2018.Day2Test do
  use ExUnit.Case
  import AoC.Year2018.Day2

  test "checksum" do
    input = """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    assert 12 == checksum(input)
  end
end
