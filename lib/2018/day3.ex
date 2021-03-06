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

  def no_overlap2(input) do
    {fabric, ids} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({%{}, []}, fn line, {fabric_acc, ids} ->
        # example: #3 @ 1,3: 2x2
        [id_str, _, start_str, size_str] = String.split(line, " ", trim: true)

        elf_id =
          id_str
          |> String.trim_leading("#")
          |> String.to_integer()

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

        new_fabric =
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

        {new_fabric, [elf_id | ids]}
      end)

    fabric
    |> Enum.reduce(ids, fn {_, claimers}, good_ids ->
      if length(claimers) > 1 do
        Enum.reduce(claimers, good_ids, fn id, acc -> List.delete(acc, id) end)
      else
        good_ids
      end
    end)
    |> List.first()
  end

  def no_overlap(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      # example: #3 @ 1,3: 2x2
      [id_str, _, start_str, size_str] = String.split(line, " ", trim: true)

      elf_id =
        id_str
        |> String.trim_leading("#")
        |> String.to_integer()

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

      {
        elf_id,
        {start_x, start_x + width - 1, start_y, start_y + height - 1}
      }
    end)
    |> remove_overlap([])
  end

  defp remove_overlap([{id, _}], _), do: id

  # check overlaps with a claim that was overlapped by another claim
  defp remove_overlap(other_claims, [claim_a | rest_overlaps]) do
    {new_overlaps, left} =
      other_claims
      |> Enum.reduce({rest_overlaps, []}, fn claim_b, {overlaps_acc, left_acc} ->
        if is_overlap?(claim_a, claim_b) do
          {[claim_b | overlaps_acc], left_acc}
        else
          {overlaps_acc, [claim_b | left_acc]}
        end
      end)

    remove_overlap(left, new_overlaps)
  end

  # randomly find a claim that overlaps with any other claim
  defp remove_overlap([claim_a | rest_claims] = claims, []) do
    case Enum.any?(rest_claims, fn claim_b -> is_overlap?(claim_a, claim_b) end) do
      true ->
        remove_overlap(rest_claims, [claim_a])

      _ ->
        claims
        |> Enum.shuffle()
        |> remove_overlap([])
    end
  end

  defp is_overlap?({_, {x_a1, x_a2, y_a1, y_a2}}, {_, {x_b1, x_b2, y_b1, y_b2}}) do
    cond do
      x_a1 > x_b2 || x_b1 > x_a2 ->
        false

      y_a2 < y_b1 || y_b2 < y_a1 ->
        false

      true ->
        true
    end
  end
end
