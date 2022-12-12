defmodule Solution do
  defmodule Monkey do
    defstruct items: [], inspection: {:old, :plus, 0}, test_divisor: 1, test_true_target: 0, test_false_target: 0, inspections: 0
  end

  def part1() do
    monkeys = input()
    [a, b] = 1..20
      |> Enum.reduce(monkeys, &play_round/2)
      |> Map.values
      |> Enum.map(fn monkey -> monkey.inspections end)
      |> Enum.sort(:desc)
      |> Enum.take(2)
    a * b
  end

  def part2() do
    monkeys = input()
    # Find a common denominator by multiplying all the test divisors together.
    # lcd = monkeys
    #   |> Map.values
    #   |> Enum.map(fn m -> m.test_divisor end)
    #   |> Enum.reduce(&Kernel.*/2)
    [a, b] = 1..10_000
      |> Enum.reduce(monkeys, &play_round/2)
      |> Map.values
      |> Enum.map(fn monkey -> monkey.inspections end)
      |> Enum.sort(:desc)
      |> Enum.take(2)
    a * b
  end

  defp input() do
    # Can't be bothered to parse the input file
    %{
      0 => %Monkey{
        items: [89, 95, 92, 64, 87, 68],
        inspection: {:old, :multiply, 11},
        test_divisor: 2,
        test_true_target: 7,
        test_false_target: 4,
      },
      1 => %Monkey{
        items: [87, 67],
        inspection: {:old, :add, 1},
        test_divisor: 13,
        test_true_target: 3,
        test_false_target: 6,
      },
      2 => %Monkey{
        items: [95, 79, 92, 82, 60],
        inspection: {:old, :add, 6},
        test_divisor: 3,
        test_true_target: 1,
        test_false_target: 6,
      },
      3 => %Monkey{
        items: [67, 97, 56],
        inspection: {:old, :multiply, :old},
        test_divisor: 17,
        test_true_target: 7,
        test_false_target: 0,
      },
      4 => %Monkey{
        items: [80, 68, 87, 94, 61, 59, 50, 68],
        inspection: {:old, :multiply, 7},
        test_divisor: 19,
        test_true_target: 5,
        test_false_target: 2,
      },
      5 => %Monkey{
        items: [73, 51, 76, 59],
        inspection: {:old, :add, 8},
        test_divisor: 7,
        test_true_target: 2,
        test_false_target: 1,
      },
      6 => %Monkey{
        items: [92],
        inspection: {:old, :add, 5},
        test_divisor: 11,
        test_true_target: 3,
        test_false_target: 0,
      },
      7 => %Monkey{
        items: [99, 76, 78, 76, 79, 90, 89],
        inspection: {:old, :add, 7},
        test_divisor: 5,
        test_true_target: 4,
        test_false_target: 5,
      },
    }
  end

  defp play_round(_round_index, monkeys) do
    n_monkeys =
      monkeys
      |> Map.keys
      |> length
    0..(n_monkeys - 1)
      |> Enum.reduce(monkeys, &play_turn/2)
  end

  defp play_turn(monkey_index, monkeys) do
    monkey = monkeys[monkey_index]
    {_, monkeys} =
      monkey.items
      |> Enum.reduce({monkey_index, monkeys}, &inspect_item/2)
    monkeys
  end

  defp inspect_item(item_worry, {monkey_index, monkeys}) do
    monkey = monkeys[monkey_index]
    new_worry = inspection(monkey, item_worry)
    # Post-inspection worry is reduced by a factor of 3 and rounded down.
    # new_worry = trunc(new_worry / 9699690)
    new_worry = rem(new_worry, 9699690)
    # Drop the item just inspected and increment the number of inspections
    # the current monkey has done.
    [_ | items] = monkey.items
    monkey = %{monkey | items: items, inspections: monkey.inspections + 1}
    monkeys = Map.put(monkeys, monkey_index, monkey)
    # Throw the item to appropriate monkey.
    target_test = rem(new_worry, monkey.test_divisor) == 0
    target_index = if target_test, do: monkey.test_true_target, else: monkey.test_false_target
    target = monkeys[target_index]
    target_items = target.items ++ [new_worry]
    monkeys = Map.put(monkeys, target_index, %{target | items: target_items})
    {monkey_index, monkeys}
  end

  defp inspection(monkey, worry) do
    {:old, op, value} = monkey.inspection
    value =
      case value do
        :old -> worry
        _ -> value
      end
    case op do
      :add -> worry + value
      :multiply -> worry * value
    end
  end

end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"