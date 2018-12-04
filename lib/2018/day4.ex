defmodule AoC.Year2018.Day4 do
  def most(input) do
    input
    |> sort_reduce()
    |> Enum.max_by(fn {_, sleep_map} -> sleep_map |> Map.values() |> Enum.sum() end)
    |> (fn {id, sleep_map} ->
          sleep_map
          |> Enum.max_by(fn {_min, times} -> times end)
          |> Kernel.elem(0)
          |> Kernel.*(id)
        end).()
  end

  def most2(input) do
    input
    |> sort_reduce()
    |> Enum.max_by(fn {_, sleep_map} ->
      sleep_map
      |> Enum.max_by(fn {_min, times} -> times end)
      |> Kernel.elem(1)
    end)
    |> (fn {id, sleep_map} ->
          sleep_map
          |> Enum.max_by(fn {_min, times} -> times end)
          |> Kernel.elem(0)
          |> Kernel.*(id)
        end).()
  end

  defp sort_reduce(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      dt_str = String.slice(line, 1..16)
      datetime = NaiveDateTime.from_iso8601!(dt_str <> ":00")

      log_str = String.slice(line, 19..-1)
      log = extract_log(log_str)

      {datetime, log}
    end)
    |> Enum.sort_by(
      fn {dt, _} -> dt end,
      fn a, b -> NaiveDateTime.compare(a, b) != :gt end
    )
    |> Enum.reduce(
      # {state, guard_id, acc}, state can be nil | :guard | {:sleep, start_min}
      {nil, nil, %{}},
      fn
        {_, {:guard, id}}, {_, _, acc} ->
          {:guard, id, acc}

        {dt, :sleep}, {_, id, acc} ->
          {{:sleep, dt.minute}, id, acc}

        {dt, :wake}, {{:sleep, start_min}, id, acc} ->
          old_map = Map.get(acc, id, %{})

          new_map =
            start_min..(dt.minute - 1)
            |> Enum.map(fn min -> {min, 1} end)
            |> Enum.into(%{})
            |> Map.merge(
              old_map,
              fn _k, v1, v2 -> v1 + v2 end
            )

          new_acc = Map.put(acc, id, new_map)

          {nil, id, new_acc}
      end
    )
    |> Kernel.elem(2)
  end

  defp extract_log("Guard #" <> rest_str) do
    id = String.split(rest_str, " ") |> List.first() |> String.to_integer()
    {:guard, id}
  end

  defp extract_log("wakes up"), do: :wake
  defp extract_log("falls asleep"), do: :sleep
end
