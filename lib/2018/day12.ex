defmodule AoC.Year2018.Day12 do
  defmodule State do
    defstruct [:left, :right]
  end

  def sum(init_state_str, rules_txt) do
    init_state = %State{
      left: [],
      right: to_state_list(init_state_str)
    }

    rules =
      rules_txt
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, to] = String.split(line, " => ")

        from = to_state_list(from)
        to = to_state(to)

        {from, to}
      end)
      |> Enum.into(%{})

    Stream.iterate(
      init_state,
      fn state -> evolve(state, rules) end
    )
    |> Enum.at(20)
    |> do_sum()
  end

  defp to_state_list(input) do
    input
    |> String.graphemes()
    |> Enum.map(&to_state/1)
  end

  defp to_state("."), do: :empty
  defp to_state("#"), do: :alive

  defp evolve(state, rules) do
    # example state: ..# #.#.
    adjusted_state =
      state
      # after trim_empty/1: # #.#
      |> trim_empty()
      # after adjust/1: ....# #.#....
      |> adjust()

    all_pots = adjusted_state.left ++ adjusted_state.right
    new_left_len = length(adjusted_state.left) - 2

    {new_left, new_right} =
      0..(length(all_pots) - 5)
      |> Enum.map(fn start ->
        env = Enum.slice(all_pots, start, 5)

        Map.get(rules, env, :empty)
      end)
      |> Enum.split(new_left_len)

    %State{
      left: new_left,
      right: new_right
    }
    |> trim_empty()
  end

  defp trim_empty(state) do
    %State{
      left: Enum.drop_while(state.left, fn pot -> pot == :empty end),
      right:
        state.right
        |> Enum.reverse()
        |> Enum.drop_while(fn pot -> pot == :empty end)
        |> Enum.reverse()
    }
  end

  defp adjust(state) do
    %State{
      left: List.duplicate(:empty, 4) ++ state.left,
      right: state.right ++ List.duplicate(:empty, 4)
    }
  end

  defp do_sum(state) do
    minus =
      state.left
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn
        {:empty, _}, acc -> acc
        {:alive, idx}, acc -> acc + idx
      end)

    plus =
      state.right
      |> Enum.with_index()
      |> Enum.reduce(0, fn
        {:empty, _}, acc -> acc
        {:alive, idx}, acc -> acc + idx
      end)

    plus - minus
  end
end
