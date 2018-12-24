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
end
