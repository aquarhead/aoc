defmodule AoC.Year2018.Day2Test do
  use ExUnit.Case
  @moduletag finished: true

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

  test "common" do
    input = """
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """

    assert "fgij" == common(input)
  end
end
