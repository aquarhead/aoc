defmodule AoC.Year2018.Day15 do
  defmodule Mob do
    defstruct [:race, :attack, :hp]

    defimpl Inspect do
      def inspect(mob, _) do
        case mob.race do
          :elf -> "E"
          :goblin -> "G"
        end <> " #{mob.hp}"
      end
    end
  end

  def combat_outcome(input) do
    {pos_mobs, map} = read_input(input)

    Stream.iterate(0, fn x -> x + 1 end)
    |> Enum.reduce_while(
      {pos_mobs, map},
      fn fin_rounds, {pos_mobs, map} ->
        case play_round(pos_mobs, map) do
          {:end, mobs_list} ->
            {:halt, fin_rounds * hp_left(mobs_list)}

          next_acc ->
            {:cont, next_acc}
        end
      end
    )
  end

  def debug_stream(input) do
    Stream.iterate(
      read_input(input),
      fn {mobs, map} -> play_round(mobs, map) end
    )
  end

  def debug_print({mobs, map}, width, height) do
    IO.write(" ")

    for x <- 0..(width - 1) do
      rem(x, 10) |> Integer.to_string() |> IO.write()
    end

    IO.puts("")

    for y <- 0..(height - 1) do
      rem(y, 10) |> Integer.to_string() |> IO.write()

      for x <- 0..(width - 1) do
        mob = Map.get(mobs, {x, y}, nil)

        case mob do
          nil ->
            if {x, y} in map do
              IO.write(".")
            else
              IO.write("#")
            end

          mob ->
            if mob.race == :elf do
              IO.write("E")
            else
              IO.write("G")
            end
        end
      end

      IO.puts("")
    end

    :ok
  end

  defp read_input(input, elf_power \\ 3) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {tile, x} -> {x, y, tile} end)
    end)
    |> Enum.reduce(
      {%{}, []},
      fn {x, y, tile}, {mobs_acc, map_acc} ->
        case tile do
          ?G ->
            goblin = %Mob{race: :goblin, attack: 3, hp: 200}

            {
              Map.put(mobs_acc, {x, y}, goblin),
              map_acc
            }

          ?E ->
            elf = %Mob{race: :elf, attack: elf_power, hp: 200}

            {
              Map.put(mobs_acc, {x, y}, elf),
              map_acc
            }

          ?. ->
            {
              mobs_acc,
              [{x, y} | map_acc]
            }

          _ ->
            {mobs_acc, map_acc}
        end
      end
    )
  end

  defp hp_left(mobs) do
    Enum.reduce(mobs, 0, fn mob, acc -> acc + mob.hp end)
  end

  defp play_round(pos_mobs, map) do
    pos_mobs
    |> Enum.map(fn {pos, _mob} -> pos end)
    |> Enum.sort(&read_order_sorter/2)
    |> play_turn(pos_mobs, map)
  end

  defp read_order_sorter({x1, y1}, {x2, y2}) do
    y1 < y2 || (y1 == y2 && x1 <= x2)
  end

  defp play_turn([], mobs, map), do: {mobs, map}

  defp play_turn([pos | rest], mobs, map) do
    current_mob = Map.get(mobs, pos, nil)

    if current_mob == nil do
      play_turn(rest, mobs, map)
    else
      target = best_target(mobs, pos, current_mob.race)

      # only execute first true condition
      cond do
        no_more_enemy?(mobs, current_mob.race) ->
          # end combat
          {:end, Map.values(mobs)}

        target != nil ->
          # attack
          {new_mobs, new_map, new_rest} = attack(current_mob, mobs, target, map, rest)

          play_turn(new_rest, new_mobs, new_map)

        true ->
          # move + try attack
          {mobs2, map2, new_pos} = move(mobs, pos, current_mob, map)

          {new_mobs, new_map, new_rest} =
            case best_target(mobs2, new_pos, current_mob.race) do
              nil ->
                {mobs2, map2, rest}

              target ->
                attack(current_mob, mobs2, target, map2, rest)
            end

          play_turn(new_rest, new_mobs, new_map)
      end
    end
  end

  defp no_more_enemy?(mobs, race) do
    Enum.all?(mobs, fn {_pos, mob} -> mob.race == race end)
  end

  defp best_target(mobs, pos1, race) do
    least_hp_targets =
      mobs
      |> Enum.filter(fn {pos2, %Mob{race: race2}} ->
        adjacent?(pos1, pos2) && race2 != race
      end)
      |> Enum.group_by(fn {_pos, %Mob{hp: hp}} -> hp end)
      |> Enum.min_by(fn {hp, _pos_mobs} -> hp end, fn -> nil end)

    case least_hp_targets do
      nil ->
        nil

      {_, targets} ->
        targets
        |> Enum.sort_by(fn {pos, _} -> pos end, &read_order_sorter/2)
        |> List.first()
    end
  end

  defp adjacent?({x1, y1}, {x2, y2}) do
    abs(x2 - x1) + abs(y2 - y1) == 1
  end

  defp attack(attacker, mobs, {pos, target}, map, rest) do
    new_hp = target.hp - attacker.attack

    if new_hp > 0 do
      {
        Map.update!(mobs, pos, fn mob -> %Mob{mob | hp: new_hp} end),
        map,
        rest
      }
    else
      {
        Map.delete(mobs, pos),
        [pos | map],
        List.delete(rest, pos)
      }
    end
  end

  defp move(mobs, pos, current_mob, map) do
    destination =
      map
      |> reachable_map(pos)
      |> Enum.group_by(fn {_, _, steps} -> steps end, fn {x, y, _} -> {x, y} end)
      |> Enum.sort_by(fn {steps, _} -> steps end)
      # remove steps == 0
      |> Enum.slice(1..-1)
      |> Enum.find_value(fn {_, poses} ->
        possible_dests =
          Enum.filter(poses, fn pos2 ->
            # pos2 is next to any enemy
            Enum.any?(mobs, fn {pos1, mob1} ->
              adjacent?(pos1, pos2) && mob1.race != current_mob.race
            end)
          end)

        case possible_dests do
          [] ->
            false

          dests ->
            dests
            |> Enum.sort(&read_order_sorter/2)
            |> List.first()
        end
      end)

    case destination do
      nil ->
        {mobs, map, pos}

      destination ->
        # find next step
        new_pos =
          map
          |> reachable_map(destination)
          |> Enum.filter(fn {x2, y2, _} ->
            adjacent?(pos, {x2, y2})
          end)
          |> Enum.group_by(fn {_, _, steps} -> steps end, fn {x, y, _} -> {x, y} end)
          |> Enum.min_by(fn {steps, _} -> steps end)
          |> Kernel.elem(1)
          |> Enum.sort(&read_order_sorter/2)
          |> List.first()

        # move

        new_mobs =
          mobs
          |> Map.delete(pos)
          |> Map.put(new_pos, current_mob)

        new_map =
          map
          |> List.delete(new_pos)
          |> List.insert_at(0, pos)

        {new_mobs, new_map, new_pos}
    end
  end

  defp reachable_map(map, {x, y}) do
    do_reachable_map([{x, y, 0}], [], map)
  end

  defp do_reachable_map([], reachable, _), do: reachable
  defp do_reachable_map(search, reachable, []), do: search ++ reachable

  defp do_reachable_map([{x1, y1, steps} = a | rest], acc, map) do
    by_adjacent = Enum.group_by(map, fn pos2 -> adjacent?({x1, y1}, pos2) end)

    new_rest =
      by_adjacent
      |> Map.get(true, [])
      |> Enum.map(fn {x, y} -> {x, y, steps + 1} end)
      |> Enum.into(rest)
      |> Enum.sort_by(fn {_, _, steps} -> steps end)

    new_acc = [a | acc]

    new_map = Map.get(by_adjacent, false, [])

    do_reachable_map(new_rest, new_acc, new_map)
  end

  def help_elves(input) do
    {mobs0, _} = read_input(input)

    num_elves = count_elves(mobs0)

    Stream.iterate(4, &(&1 + 1))
    |> Stream.map(fn elf_power ->
      {pos_mobs, map} = read_input(input, elf_power)

      Stream.iterate(0, fn x -> x + 1 end)
      |> Enum.reduce_while(
        {pos_mobs, map},
        fn fin_rounds, {pos_mobs, map} ->
          case play_round(pos_mobs, map) do
            {:end, mobs_list} ->
              {:halt, fin_rounds * hp_left(mobs_list)}

            {new_mobs, _} = next_acc ->
              case count_elves(new_mobs) do
                ^num_elves -> {:cont, next_acc}
                _ -> {:halt, :bad_power}
              end
          end
        end
      )
    end)
    |> Stream.drop_while(fn result ->
      result == :bad_power
    end)
    |> Enum.at(0)
  end

  defp count_elves(pos_mobs),
    do: Enum.count(pos_mobs, fn {_, %Mob{race: race}} -> race == :elf end)
end
