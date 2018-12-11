defmodule AoC.Year2018.Day11 do
  @map_size 300

  def largest(serial) do
    for x <- 1..@map_size do
      for y <- 1..@map_size do
        pos = {x, y}
        {pos, power_level(pos, serial)}
      end
    end
    |> List.flatten()
    |> Enum.into(%{})
    |> largest_square()
  end

  defp power_level({x, y}, serial) do
    x
    |> Kernel.+(10)
    |> Kernel.*(y)
    |> Kernel.+(serial)
    |> Kernel.*(x + 10)
    |> Kernel.div(100)
    |> Kernel.rem(10)
    |> Kernel.-(5)
  end

  @square_size 3
  @offsets List.flatten(
             for dx <- 0..(@square_size - 1) do
               for dy <- 0..(@square_size - 1) do
                 {dx, dy}
               end
             end
           )

  defp largest_square(map) do
    for x <- 1..(@map_size - @square_size + 1) do
      for y <- 1..(@map_size - @square_size + 1) do
        pos = {x, y}

        {pos, square_sum(map, pos)}
      end
    end
    |> List.flatten()
    |> Enum.max_by(fn {_pos, sum} -> sum end)
    |> Kernel.elem(0)
  end

  defp square_sum(map, {x, y}) do
    for {dx, dy} <- @offsets do
      Map.get(map, {x + dx, y + dy}, nil)
    end
    |> Enum.sum()
  end
end
