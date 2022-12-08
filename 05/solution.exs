defmodule Solution do
  def part1() do
    input()
      |> Enum.reduce(initial_state(), &move_blocks_queue/2)
      |> state_heads
  end

  def part2() do
    input()
      |> Enum.reduce(initial_state(), &move_blocks_stack/2)
      |> state_heads
  end
  
  defp initial_state() do
    # I can't be bothered to parse the cute ASCII art :)
    %{
      1 => ~w(T Q V C D S N),
      2 => ~w(V F M),
      3 => ~w(M H N P D W Q F),
      4 => ~w(F T R Q D),
      5 => ~w(B V H Q N M F R),
      6 => ~w(Q W P N G F C),
      7 => ~w(T C L R F W),
      8 => ~w(S N Z T),
      9 => ~w(N H Q R J D S M),
    }
  end
  
  defp input() do
    File.stream!("05/input.txt")
      |> Enum.map(&line_to_instructions/1)
  end
  
  defp line_to_instructions(line) do
    line
      |> String.trim
      |> String.replace(["move ", "from ", "to "], "")
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
  end
  
  defp move_blocks_queue([count, source, destination], state) do
    # Move `count` blocks from the `source` list of `state` to the
    # `destination` list of `state` in a queue-like fashion, i.e.
    # the first block popped from `source` is the first block
    # pushed to `destination`.
    {source_head, new_source} = Enum.split(state[source], count)
    %{state | 
      destination =>
        source_head
        |> Enum.reverse
        |> Enum.concat(state[destination]),
      source => new_source}
  end
  
  defp move_blocks_stack([count, source, destination], state) do
    # Move `count` blocks from the `source` list of `state` to the
    # `destination` list of `state` in a stack-like fashion, i.e.
    # the first block popped from `source` is the first block
    # pushed to `destination`.
    # Identical to `move_blocks_queue` except the blocks from `source`
    # are not reversed.
    {source_head, new_source} = Enum.split(state[source], count)
    %{state | 
      destination =>
        source_head
        |> Enum.concat(state[destination]),
      source => new_source}
  end
  
  defp state_heads(state) do
    Map.keys(state)
      |> Enum.sort
      |> Enum.map(&(Map.get(state, &1)))
      |> Enum.map(fn [head | _] -> head end)
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"