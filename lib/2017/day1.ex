defmodule AoC.Year2017.Day1 do
  def sum(input) do
    nums = to_int_list(input)
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

  def sum2(input) do
    nums = to_int_list(input)

    half_len = div(length(nums), 2)
    sec_half = Enum.slice(nums, half_len, half_len)

    Enum.into(nums, sec_half)
    |> Enum.zip(nums)
    |> Enum.filter(fn {x, y} -> x == y end)
    |> Enum.reduce(0, fn
      {x, x}, acc -> acc + x
      _, acc -> acc
    end)
  end

  defp to_int_list(str) do
    str
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
