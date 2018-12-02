defmodule AoC.Year2017.Day2 do
  def checksum(input) do
    lines = to_int_matrix(input)

    lines
    |> Enum.map(fn line ->
      Enum.max(line) - Enum.min(line)
    end)
    |> Enum.sum()
  end

  def checksum2(input) do
  end

  defp to_int_matrix(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
