defmodule AoC.Year2018.Day9 do
  defmodule CircleZipper do
    defstruct [
      :focus,
      :counter_clockwise,
      :clockwise
    ]

    @type t :: %__MODULE__{
            focus: integer(),
            counter_clockwise: list(integer()),
            clockwise: list(integer())
          }
  end

  def high_score(num_players, last_marble) do
    init_circle = %CircleZipper{focus: 0, counter_clockwise: [], clockwise: []}

    1..num_players
    |> Stream.cycle()
    |> Stream.with_index(1)
    |> Stream.scan(
      {List.duplicate(0, num_players), init_circle},
      fn {player, marble}, {scores_acc, circle} ->
        {score, new_circle} = place_marble(marble, circle)
        new_scores = List.update_at(scores_acc, player - 1, fn s -> s + score end)

        {new_scores, new_circle}
      end
    )
    |> Enum.at(last_marble - 1)
    |> Kernel.elem(0)
    |> Enum.max()
  end

  @spec place_marble(integer(), CircleZipper.t()) :: {score :: integer(), CircleZipper.t()}
  defp place_marble(marble, circle) when rem(marble, 23) == 0 do
    {left, [score_marble, new_focus | right]} =
      Enum.split(circle.clockwise ++ circle.counter_clockwise, -7)

    {marble + score_marble,
     %CircleZipper{
       focus: new_focus,
       counter_clockwise: left,
       clockwise: right ++ [circle.focus]
     }}
  end

  defp place_marble(marble, circle) do
    case circle.clockwise do
      [] ->
        {left, right} = Enum.split(circle.counter_clockwise, 1)

        {0,
         %CircleZipper{
           focus: marble,
           counter_clockwise: left,
           clockwise: right ++ [circle.focus]
         }}

      [h | t] ->
        {0,
         %CircleZipper{
           focus: marble,
           counter_clockwise: circle.counter_clockwise ++ [circle.focus, h],
           clockwise: t
         }}
    end
  end
end
