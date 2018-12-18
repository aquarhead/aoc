defmodule AoC.Year2018.Day14 do
  def ten_scores(after_index) do
    recipe_stream()
    |> Stream.drop(after_index)
    |> Enum.take(10)
    |> Enum.join()
  end

  def recipe_stream() do
    Stream.resource(
      fn -> nil end,
      fn
        nil ->
          first_acc = {[3, 7], 0, 1}
          {[3, 7], first_acc}

        {nums, idx1, idx2} ->
          score1 = Enum.at(nums, idx1)
          score2 = Enum.at(nums, idx2)

          sum = score1 + score2

          new_scores =
            if sum >= 10 do
              [1, sum - 10]
            else
              [sum]
            end

          new_nums = nums ++ new_scores

          new_idx1 = Integer.mod(1 + score1 + idx1, length(new_nums))
          new_idx2 = Integer.mod(1 + score2 + idx2, length(new_nums))

          next_acc = {
            new_nums,
            new_idx1,
            new_idx2
          }

          {new_scores, next_acc}
      end,
      fn _ -> nil end
    )
  end
end
