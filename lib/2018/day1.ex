defmodule AoC.Year2018.Day1 do
  def freq(input, splitter \\ ",") do
    input
    |> String.split(splitter, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def freq2(input, splitter \\ ",") do
    input
    |> String.split(splitter, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Enum.reduce_while([0], fn change, [current_freq | _] = acc ->
      new_freq = current_freq + change
      case Enum.member?(acc, new_freq) do
        false -> {:cont, [new_freq | acc]}
        true -> {:halt, new_freq}
      end
    end)
  end
end
