defmodule AoC.Year2018.Day11 do
  @map_size 300

  def largest(serial) do
    {{x, y}, _, _} =
      for x <- 1..@map_size do
        for y <- 1..@map_size do
          pos = {x, y}
          {pos, power_level(pos, serial)}
        end
      end
      |> List.flatten()
      |> Enum.into(%{})
      |> largest_square(3)

    "#{x},#{y}"
  end

  def largest_any(serial) do
    map =
      for x <- 1..@map_size do
        for y <- 1..@map_size do
          pos = {x, y}
          {pos, power_level(pos, serial)}
        end
      end
      |> List.flatten()
      |> Enum.into(%{})

    {{x, y}, size, _} =
      Task.async_stream(
        1..@map_size,
        fn size ->
          largest_square(map, size)
        end,
        timeout: :infinity
      )
      |> Enum.map(fn {:ok, res} -> res |> IO.inspect() end)
      |> Enum.max_by(fn {_, _, sum} -> sum end)

    "#{x},#{y},#{size}"
  end

  defp prime_grid(serial) do
    for y <- 1..@map_size do
      for x <- 1..@map_size do
        power_level({x, y}, serial)
      end
    end
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

  defp largest_square(map, size) do
    offsets =
      for dx <- 0..(size - 1) do
        for dy <- 0..(size - 1) do
          {dx, dy}
        end
      end
      |> List.flatten()

    {pos, sum} =
      for x <- 1..(@map_size - size + 1) do
        for y <- 1..(@map_size - size + 1) do
          pos = {x, y}

          {pos, square_sum(map, pos, offsets)}
        end
      end
      |> List.flatten()
      |> Enum.max_by(fn {_pos, sum} -> sum end)

    {pos, size, sum}
  end

  defp square_sum(map, {x, y}, offsets) do
    for {dx, dy} <- offsets do
      Map.get(map, {x + dx, y + dy}, nil)
    end
    |> Enum.sum()
  end
end
