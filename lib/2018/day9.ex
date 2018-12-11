defmodule AoC.Year2018.Day9 do
  defmodule CircleZipper do
    @moduledoc """
    A zipper for the circle in this puzzle.

    `left` and `right` all goes from "center" (`focus`), aka. for a list
    [1, 2, 3, 4, 5] with `focus` on `3`, `left` is `[2, 1]`, `right` is `[4, 5]`
    """

    defstruct [
      :focus,
      :left,
      :left_len,
      :right
    ]

    @type t :: %__MODULE__{
            focus: integer(),
            left: list(integer()),
            left_len: integer(),
            right: list(integer())
          }
  end

  def high_score(num_players, last_marble) do
    init_circle = %CircleZipper{focus: 0, left: [], left_len: 0, right: []}

    1..num_players
    |> Stream.cycle()
    |> Stream.with_index(1)
    |> Stream.scan(
      {:array.new(num_players, default: 0), init_circle},
      fn {player, marble}, {scores_acc, circle} ->
        {score, new_circle} = place_marble(marble, circle)

        new_scores =
          if score > 0 do
            old_score = :array.get(player - 1, scores_acc)
            :array.set(player - 1, old_score + score, scores_acc)
          else
            scores_acc
          end

        {new_scores, new_circle}
      end
    )
    |> Enum.at(last_marble - 1)
    |> Kernel.elem(0)
    |> :array.to_list()
    |> Enum.max()
  end

  @spec place_marble(integer(), CircleZipper.t()) :: {score :: integer(), CircleZipper.t()}
  defp place_marble(marble, circle) when rem(marble, 23) == 0 do
    {score_marble, new_circle} =
      if circle.left_len >= 7 do
        {right_head_rev, [new_focus, score_marble | t]} = Enum.split(circle.left, 5)

        new_circle = %CircleZipper{
          focus: new_focus,
          left: t,
          left_len: circle.left_len - 7,
          right: Enum.reverse([circle.focus | right_head_rev]) ++ circle.right
        }

        {score_marble, new_circle}
      else
        counter_clockwise = circle.left ++ Enum.reverse(circle.right)

        {right_head_rev, [new_focus, score_marble | t]} = Enum.split(counter_clockwise, 5)

        new_circle = %CircleZipper{
          focus: new_focus,
          left: t,
          left_len: length(t),
          right: Enum.reverse([circle.focus | right_head_rev])
        }

        {score_marble, new_circle}
      end

    {marble + score_marble, new_circle}
  end

  defp place_marble(marble, circle) do
    new_circle =
      case circle.right do
        [] ->
          [h | t] = Enum.reverse([circle.focus | circle.left])

          %CircleZipper{
            focus: marble,
            left: [h],
            left_len: 1,
            right: t
          }

        [h | t] ->
          %CircleZipper{
            focus: marble,
            left: [h, circle.focus | circle.left],
            left_len: circle.left_len + 2,
            right: t
          }
      end

    {0, new_circle}
  end
end
