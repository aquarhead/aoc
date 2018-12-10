defmodule AoC.Year2018.Day7 do
  def order(input) do
    input
    |> group_input()
    |> resolve_order([], "")
  end

  defp group_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      parts = String.split(line, " ", trim: true)

      step = Enum.at(parts, 1)
      dep = Enum.at(parts, 7)

      {step, dep}
    end)
    |> Enum.group_by(fn {step, _} -> step end, fn {_, dep} -> dep end)
  end

  defp resolve_order(step_deps, valid_steps, order_acc)

  # finished resolving, output acc
  defp resolve_order(empty, [], acc) when map_size(empty) == 0, do: acc

  # add valid steps
  defp resolve_order(step_deps, [], acc) do
    valid_steps =
      step_deps
      |> Map.keys()
      |> Enum.filter(fn step ->
        is_valid_step?(step_deps, step)
      end)
      |> Enum.sort()

    resolve_order(step_deps, valid_steps, acc)
  end

  # select first step, and add valid steps
  defp resolve_order(step_deps, [next_step | rest], acc) do
    {more_valid_steps, new_step_deps} = pop_deps_filter_valid(step_deps, next_step)

    new_valid_steps =
      more_valid_steps
      |> Enum.into(rest)
      |> Enum.sort()

    resolve_order(new_step_deps, new_valid_steps, acc <> next_step)
  end

  defp is_valid_step?(step_deps, step) do
    step_deps
    |> Map.values()
    |> List.flatten()
    |> Enum.all?(fn dep -> not String.equivalent?(step, dep) end)
  end

  defp pop_deps_filter_valid(step_deps, step) do
    {deps, new_step_deps} = Map.pop(step_deps, step, [])

    valid_steps =
      deps
      |> Enum.filter(fn s ->
        is_valid_step?(new_step_deps, s)
      end)

    {valid_steps, new_step_deps}
  end

  def time(input, num_worker, time_offset) do
    input
    |> group_input()
    |> resolve_time(
      [],
      List.duplicate({0, nil}, num_worker),
      0,
      time_offset
    )
  end

  # workers -> [{finish_time, step}]
  defp resolve_time(step_deps, valid_steps, workers, now, time_offset)

  # all works started, just grab the last finish time
  defp resolve_time(empty, [], [{finish_time, _} | _], _, _) when map_size(empty) == 0,
    do: finish_time

  # get more valid steps
  defp resolve_time(step_deps, [], [{fin, _} | _] = workers, fin, time_offset) do
    valid_steps =
      step_deps
      |> Map.keys()
      |> Enum.filter(fn step ->
        is_valid_step?(step_deps, step)
      end)
      |> Enum.sort()

    {sorted_workers, left_valid_steps} = distribute_works(valid_steps, workers, fin, time_offset)

    resolve_time(step_deps, left_valid_steps, sorted_workers, fin, time_offset)
  end

  defp resolve_time(step_deps, valid_steps, workers, prev, time_offset) do
    # advance time, get workers that will finish
    {now, _} =
      workers
      |> Enum.reverse()
      |> Enum.find(fn {t, _} -> t > prev end)

    finished_workers =
      workers
      |> Enum.filter(fn {t, _} -> t == now end)

    # add more valid steps
    {more_valid_steps, new_step_deps} =
      Enum.reduce(
        finished_workers,
        {[], step_deps},
        fn {_, finish_step}, {valid_steps_acc, step_deps_acc} ->
          {vs, nsd} = pop_deps_filter_valid(step_deps_acc, finish_step)

          {Enum.into(vs, valid_steps_acc), nsd}
        end
      )

    new_valid_steps =
      more_valid_steps
      |> Enum.into(valid_steps)
      |> Enum.sort()

    # try distribute works
    {sorted_workers, left_valid_steps} =
      distribute_works(new_valid_steps, workers, now, time_offset)

    resolve_time(new_step_deps, left_valid_steps, sorted_workers, now, time_offset)
  end

  defp time_for_step(step), do: step |> String.to_charlist() |> List.first() |> Kernel.-(?A - 1)

  defp distribute_works(steps, workers, now, time_offset) do
    {new_workers, left_valid_steps} =
      Enum.reduce(
        workers,
        {[], steps},
        fn
          {fin_time, _}, {workers_acc, [step | rest]} when fin_time <= now ->
            new_finish_time = now + time_for_step(step) + time_offset

            {[{new_finish_time, step} | workers_acc], rest}

          worker, {workers_acc, steps_acc} ->
            {[worker | workers_acc], steps_acc}
        end
      )

    sorted_workers =
      new_workers
      |> Enum.sort_by(fn {t, _} -> t end)
      |> Enum.reverse()

    {sorted_workers, left_valid_steps}
  end
end
