defmodule AoC.Year2018.Day6 do
  def largest(input) do
    points =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {line, id} ->
        [x_str, y_str] = String.split(line, ", ", trim: true)

        {
          id,
          String.to_integer(x_str),
          String.to_integer(y_str)
        }
      end)

    {min_x, max_x} =
      points
      |> Enum.map(fn {_, x, _} -> x end)
      |> Enum.min_max()

    {min_y, max_y} =
      points
      |> Enum.map(fn {_, _, y} -> y end)
      |> Enum.min_max()

    closest_map =
      min_x..max_x
      |> Enum.flat_map(fn x ->
        min_y..max_y
        |> Enum.map(fn y -> {x, y} end)
      end)
      |> Enum.reduce(%{}, fn pos, acc ->
        Map.put(acc, pos, closest(points, pos))
      end)

    points
    |> Enum.reject(fn point ->
      extends_infinitely?(closest_map, point, min_x, max_x, min_y, max_y)
    end)
    |> Enum.map(fn {id, _, _} ->
      Enum.count(closest_map, fn {_, v} -> v == id end)
    end)
    |> Enum.max(fn -> 0 end)
  end

  defp closest(points, {x, y}) do
    dists =
      points
      |> Enum.map(fn {id, px, py} ->
        {id, abs(px - x) + abs(py - y)}
      end)

    {_, min_dist} = Enum.min_by(dists, fn {_, dist} -> dist end)

    case Enum.filter(dists, fn {_, dist} -> dist == min_dist end) do
      [{id, _}] -> id
      # multiple closest, use nil
      _ -> nil
    end
  end

  defp extends_infinitely?(closest_map, {id, x, y}, min_x, max_x, min_y, max_y) do
    [
      {x, min_y},
      {x, max_y},
      {min_x, y},
      {max_x, y}
    ]
    |> Enum.any?(fn boundary_pos ->
      Map.get(closest_map, boundary_pos) == id
    end)
  end
end
