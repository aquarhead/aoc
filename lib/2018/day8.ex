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
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> read_node()
    |> Kernel.elem(0)
    |> sum_metadata()
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
      children: children,
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
end
