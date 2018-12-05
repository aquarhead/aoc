defmodule AoC.Year2018.Day5 do
  @offset List.first(~C(a)) - List.first(~C(A))

  def react(input) do
    input
    |> String.to_charlist()
    |> do_react()
  end

  def shortest(input) do
    units =
      input
      |> String.to_charlist()

    a = List.first(~C(a))
    z = List.first(~C(z))

    Range.new(a, z)
    |> Enum.map(fn rm_unit ->
      units
      |> Enum.reject(fn unit -> unit == rm_unit || unit == rm_unit - @offset end)
      |> do_react()
    end)
    |> Enum.min()
  end

  defp do_react(units) do
    units
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
