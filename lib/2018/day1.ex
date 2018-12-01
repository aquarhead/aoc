defmodule AoC.Year2018.Day1 do
  def freq(input, splitter \\ ",") do
    input
    |> String.split(splitter, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
