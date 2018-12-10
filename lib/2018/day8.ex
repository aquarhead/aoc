defmodule AoC.Year2018.Day8 do
  # TODO: use Zipper? https://www.wikiwand.com/en/Zipper_(data_structure)

  defmodule Node do
    defstruct [:children, :metadata]

    @type t :: %__MODULE__{
            children: list(Node.t()),
            metadata: nonempty_list(integer())
          }
  end

  def sum(input) do
    input
    |> build_tree()
    |> sum_metadata()
  end

  defp build_tree(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> read_node()
    |> Kernel.elem(0)
  end

  @spec read_node(nonempty_list(integer())) :: {Node.t(), list(integer())}
  defp read_node([num_children, num_metadata | data]) do
    {children, data_rest} =
      case num_children do
        0 ->
          {[], data}

        _ ->
          Enum.reduce(
            1..num_children,
            {[], data},
            fn _, {acc, data_in} ->
              {child_node, data_rest} = read_node(data_in)
              {[child_node | acc], data_rest}
            end
          )
      end

    {metadata, data_left} = Enum.split(data_rest, num_metadata)

    node = %Node{
      children: Enum.reverse(children),
      metadata: metadata
    }

    {node, data_left}
  end

  defp sum_metadata(node), do: do_sum_metadata([node], 0)

  defp do_sum_metadata([], acc), do: acc

  defp do_sum_metadata([node | rest], acc) do
    do_sum_metadata(
      Enum.into(node.children, rest),
      acc + Enum.sum(node.metadata)
    )
  end

  def value(input) do
    input
    |> build_tree()
    |> calc_value()
  end

  defp calc_value(nil), do: 0

  defp calc_value(node) do
    case node.children do
      [] ->
        Enum.sum(node.metadata)

      _ ->
        node.metadata
        |> Enum.map(fn idx ->
          node.children
          |> Enum.at(idx - 1)
          |> calc_value()
        end)
        |> Enum.sum()
    end
  end
end
