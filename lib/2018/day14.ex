defmodule AoC.Year2018.Day14 do
  def ten_scores(after_index) do
    recipe_stream()
    |> Stream.drop(after_index)
    |> Enum.take(10)
    |> Enum.join()
  end

  defp recipe_stream() do
    Stream.resource(
      fn -> nil end,
      fn
        nil ->
          ary0 = :array.new()
          ary1 = :array.set(0, 3, ary0)
          ary = :array.set(1, 7, ary1)

          first_acc = {ary, 0, 1}
          {[3, 7], first_acc}

        {ary, idx1, idx2} ->
          score1 = :array.get(idx1, ary)
          score2 = :array.get(idx2, ary)

          sum = score1 + score2

          ary_size = :array.size(ary)

          {new_scores, new_ary} =
            if sum >= 10 do
              ary1 = :array.set(ary_size, 1, ary)
              ary2 = :array.set(ary_size + 1, sum - 10, ary1)

              {[1, sum - 10], ary2}
            else
              {[sum], :array.set(ary_size, sum, ary)}
            end

          new_size = :array.size(new_ary)

          new_idx1 = Integer.mod(1 + score1 + idx1, new_size)
          new_idx2 = Integer.mod(1 + score2 + idx2, new_size)

          next_acc = {
            new_ary,
            new_idx1,
            new_idx2
          }

          {new_scores, next_acc}
      end,
      fn _ -> nil end
    )
  end

  def find_pattern(pattern_str) do
    ptn = pattern_str |> String.graphemes() |> Enum.map(&String.to_integer/1)

    recipe_stream()
    |> Stream.chunk_every(length(ptn), 1)
    |> Enum.find_index(fn chunk -> chunk == ptn end)
  end
end
