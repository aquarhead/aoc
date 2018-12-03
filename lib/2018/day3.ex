defmodule AoC.Year2018.Day3 do
  def overlap(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, fabric_acc ->
      # example: #3 @ 1,3: 2x2
      [elf_id, _, start_str, size_str] = String.split(line, " ", trim: true)

      # {1, 3}
      {start_x, start_y} =
        start_str
        |> String.trim_trailing(":")
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()

      # [2, 2]
      [width, height] =
        size_str
        |> String.split("x", trim: true)
        |> Enum.map(&String.to_integer/1)

      0..(width - 1)
      # map to [{1, 3}, {2, 3}]
      |> Enum.map(fn x_offset ->
        {start_x + x_offset, start_y}
      end)
      # map to [{1, 3}, {1, 4}, {2, 3}, {2, 4}]
      |> Enum.flat_map(fn {x, y} ->
        0..(height - 1)
        |> Enum.map(fn y_offset ->
          {x, y + y_offset}
        end)
      end)
      # fill claimers
      |> Enum.reduce(fabric_acc, fn pos, in_acc ->
        Map.update(in_acc, pos, [elf_id], fn claimers -> [elf_id | claimers] end)
      end)
    end)
    |> Enum.count(fn {_, claimers} -> length(claimers) > 1 end)
  end
end
