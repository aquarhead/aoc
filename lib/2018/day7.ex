defmodule AoC.Year2018.Day7 do
  def order(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      parts = String.split(line, " ", trim: true)

      step = Enum.at(parts, 1)
      dep = Enum.at(parts, 7)

      {step, dep}
    end)
    |> Enum.group_by(fn {step, _} -> step end, fn {_, dep} -> dep end)
    |> resolve_order([], "")
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
    {deps, new_step_deps} = Map.pop(step_deps, next_step, [])

    more_steps =
      deps
      |> Enum.filter(fn step ->
        is_valid_step?(new_step_deps, step)
      end)

    new_valid_steps =
      more_steps
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
end
