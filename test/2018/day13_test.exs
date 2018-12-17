defmodule AoC.Year2018.Day13Test do
  use ExUnit.Case

  import AoC.Year2018.Day13

  test "crash" do
    input1 = """
    |
    v
    |
    |
    |
    ^
    |
    """

    assert {0, 3} == crash(input1)

    input2 = ~S(
/->-\
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
\------/
    )

    assert {7, 3} == crash(input2)
  end
end
