defmodule AoC.Year2018.Day10 do
  defmodule Star do
    defstruct [:x, :y, :vx, :vy]
  end

  def message(input) do
    input
    |> read_stars()
    |> Stream.iterate(fn stars ->
      Enum.map(stars, fn star ->
        %Star{
          x: star.x + star.vx,
          y: star.y + star.vy,
          vx: star.vx,
          vy: star.vy
        }
      end)
    end)
    |> Stream.drop_while(fn stars ->
      {min_y, max_y} =
        stars
        |> Enum.map(fn star -> star.y end)
        |> Enum.min_max()

      max_y - min_y > 9
    end)
    |> Enum.at(0)
    |> output()

    :ok
  end

  def wait(input) do
    stars = read_stars(input)

    Stream.iterate({0, stars}, fn {sec, stars} ->
      new_stars =
        Enum.map(stars, fn star ->
          %Star{
            x: star.x + star.vx,
            y: star.y + star.vy,
            vx: star.vx,
            vy: star.vy
          }
        end)

      {sec + 1, new_stars}
    end)
    |> Stream.drop_while(fn {_, stars} ->
      {min_y, max_y} =
        stars
        |> Enum.map(fn star -> star.y end)
        |> Enum.min_max()

      max_y - min_y > 9
    end)
    |> Enum.at(0)
    |> Kernel.elem(0)
  end

  def output(stars) do
    {min_y, max_y} =
      stars
      |> Enum.map(fn star -> star.y end)
      |> Enum.min_max()

    {min_x, max_x} =
      stars
      |> Enum.map(fn star -> star.x end)
      |> Enum.min_max()

    stars_map =
      stars
      |> Enum.reduce(
        %{},
        fn star, acc -> Map.put(acc, {star.x, star.y}, true) end
      )

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        if Map.has_key?(stars_map, {x, y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end
  end

  def test1 do
    """
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
    """
    |> message()
  end

  defp read_stars(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [pos_part, vel_part] = String.split(line, " velocity=<")

      [head_x_str, y_str] = String.split(pos_part, ", ")

      x =
        head_x_str
        |> String.slice(10..-1)
        |> String.trim()
        |> String.to_integer()

      y =
        y_str
        |> String.slice(0..-2)
        |> String.trim()
        |> String.to_integer()

      [vx_str, vy_str] = String.split(vel_part, ", ")

      vx =
        vx_str
        |> String.trim()
        |> String.to_integer()

      vy =
        vy_str
        |> String.slice(0..-2)
        |> String.trim()
        |> String.to_integer()

      %Star{
        x: x,
        y: y,
        vx: vx,
        vy: vy
      }
    end)
  end
end
