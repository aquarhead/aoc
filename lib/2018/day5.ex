defmodule AoC.Year2018.Day5 do
  @offset List.first(~C(a)) - List.first(~C(A))

  def react(input) do
    input
    |> String.to_charlist()
    |> Enum.reduce([], fn
      next_unit, [prev_unit | rest] = units_acc ->
        if abs(next_unit - prev_unit) == @offset do
          rest
        else
          [next_unit | units_acc]
        end

      unit, acc ->
        [unit | acc]
    end)
    |> length()
  end
end
