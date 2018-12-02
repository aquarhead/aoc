defmodule AoC.Year2018.Day2 do
  def checksum(input) do
    {count2, count3} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn box_id ->
        box_id
        |> String.trim()
        |> String.to_charlist()
        |> Enum.group_by(fn x -> x end)
        |> Enum.map(fn {_k, v} -> length(v) end)
        |> Enum.filter(fn len -> len == 2 || len == 3 end)
        |> Enum.group_by(fn x -> x end)
        |> Enum.map(fn {k, _v} -> {k, 1} end)
        |> Enum.into(%{})
      end)
      |> Enum.reduce({0, 0}, fn box_m, {acc2, acc3} ->
        {
          acc2 + Map.get(box_m, 2, 0),
          acc3 + Map.get(box_m, 3, 0)
        }
      end)

    count2 * count3
  end
end
