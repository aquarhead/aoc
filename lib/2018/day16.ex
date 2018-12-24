defmodule AoC.Year2018.Day16 do
  defmodule VM do
    import Bitwise

    defstruct regs: [0, 0, 0, 0]

    def set_regs(vm, [_, _, _, _] = new_regs) do
      %__MODULE__{vm | regs: new_regs}
    end

    def set_reg(vm, idx, val) do
      %__MODULE__{
        vm
        | regs: List.replace_at(vm.regs, idx, val)
      }
    end

    def get_reg(vm, idx), do: Enum.at(vm.regs, idx)

    def same_regs?(vm, regs) do
      vm.regs == regs
    end

    def execute(vm, :addr, a, b, c) do
      result = get_reg(vm, a) + get_reg(vm, b)

      set_reg(vm, c, result)
    end

    def execute(vm, :addi, a, b, c) do
      result = get_reg(vm, a) + b

      set_reg(vm, c, result)
    end

    def execute(vm, :mulr, a, b, c) do
      result = get_reg(vm, a) * get_reg(vm, b)

      set_reg(vm, c, result)
    end

    def execute(vm, :muli, a, b, c) do
      result = get_reg(vm, a) * b

      set_reg(vm, c, result)
    end

    def execute(vm, :banr, a, b, c) do
      result = get_reg(vm, a) &&& get_reg(vm, b)

      set_reg(vm, c, result)
    end

    def execute(vm, :bani, a, b, c) do
      result = get_reg(vm, a) &&& b

      set_reg(vm, c, result)
    end

    def execute(vm, :borr, a, b, c) do
      result = get_reg(vm, a) ||| get_reg(vm, b)

      set_reg(vm, c, result)
    end

    def execute(vm, :bori, a, b, c) do
      result = get_reg(vm, a) ||| b

      set_reg(vm, c, result)
    end

    def execute(vm, :setr, a, _b, c) do
      set_reg(vm, c, get_reg(vm, a))
    end

    def execute(vm, :seti, a, _b, c) do
      set_reg(vm, c, a)
    end

    def execute(vm, :gtir, a, b, c) do
      result =
        if a > get_reg(vm, b) do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end

    def execute(vm, :gtri, a, b, c) do
      result =
        if get_reg(vm, a) > b do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end

    def execute(vm, :gtrr, a, b, c) do
      result =
        if get_reg(vm, a) > get_reg(vm, b) do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end

    def execute(vm, :eqir, a, b, c) do
      result =
        if a == get_reg(vm, b) do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end

    def execute(vm, :eqri, a, b, c) do
      result =
        if get_reg(vm, a) == b do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end

    def execute(vm, :eqrr, a, b, c) do
      result =
        if get_reg(vm, a) == get_reg(vm, b) do
          1
        else
          0
        end

      set_reg(vm, c, result)
    end
  end

  def three_or_more(input) do
    case String.split(input, "\n\n\n", trim: true) do
      [a] -> a
      [a, _] -> a
    end
    |> String.split("\n\n", trim: true)
    |> Enum.count(fn sample -> valid_ops(sample) >= 3 end)
  end

  @ops [
    :addr,
    :addi,
    :mulr,
    :muli,
    :banr,
    :bani,
    :borr,
    :bori,
    :setr,
    :seti,
    :gtir,
    :gtri,
    :gtrr,
    :eqir,
    :eqri,
    :eqrr
  ]

  defp valid_ops(sample) do
    [before_str, ins_str, after_str] = String.split(sample, "\n", trim: true)

    before_regs =
      before_str
      |> String.slice(9..-2)
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)

    [_op_code, a, b, c] =
      ins_str
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    after_regs =
      after_str
      |> String.slice(9..-2)
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)

    vm0 = VM.set_regs(%VM{}, before_regs)

    Enum.count(@ops, fn op ->
      vm0
      |> VM.execute(op, a, b, c)
      |> VM.same_regs?(after_regs)
    end)
  end

  def reg0(input) do
    [samples, program] = String.split(input, "\n\n\n", trim: true)

    samples
    |> map_op_code()
    |> run_program(program)
    |> VM.get_reg(0)
  end

  defp map_op_code(samples) do
    samples
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(
      %{},
      fn sample, mapping_acc ->
        [before_str, ins_str, after_str] = String.split(sample, "\n", trim: true)

        [op_code, a, b, c] =
          ins_str
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)

        if length(Map.get(mapping_acc, op_code, [])) == 1 do
          # this op code already has an one-to-one mapping
          mapping_acc
        else
          before_regs =
            before_str
            |> String.slice(9..-2)
            |> String.split(", ")
            |> Enum.map(&String.to_integer/1)

          after_regs =
            after_str
            |> String.slice(9..-2)
            |> String.split(", ")
            |> Enum.map(&String.to_integer/1)

          vm0 = VM.set_regs(%VM{}, before_regs)

          possible_ops =
            Enum.filter(@ops, fn op ->
              vm0
              |> VM.execute(op, a, b, c)
              |> VM.same_regs?(after_regs)
            end)

          # remove found op code
          valid_ops =
            Enum.reduce(mapping_acc, possible_ops, fn
              {_, [op]}, ops_in ->
                List.delete(ops_in, op)

              _, ops_in ->
                ops_in
            end)

          case valid_ops do
            [op] ->
              # found a one-to-one map, clean other mapping & save
              mapping_acc
              |> Map.keys()
              |> Enum.reduce(mapping_acc, fn key, acc ->
                Map.update!(acc, key, fn ops -> List.delete(ops, op) end)
              end)
              |> Map.put(op_code, [op])

            ops ->
              Map.put(mapping_acc, op_code, ops)
          end
        end
      end
    )
    |> Enum.map(fn {k, [v]} -> {k, v} end)
    |> Enum.into(%{})
  end

  defp run_program(mapping, program) do
    program
    |> String.split("\n", trim: true)
    |> Enum.reduce(
      %VM{},
      fn line, vm ->
        [op_code, a, b, c] =
          line
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)

        VM.execute(vm, Map.get(mapping, op_code), a, b, c)
      end
    )
  end
end
