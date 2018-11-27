defmodule AoC.Year2017.Day1 do
  def sum(input) do
    nums =
      input
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    last_num = List.last(nums)

    {_, final_sum} =
      Enum.reduce(nums, {last_num, 0}, fn num, {prev_num, acc} ->
        new_acc =
          if num == prev_num do
            acc + num
          else
            acc
          end

        {num, new_acc}
      end)

    final_sum
  end
end
