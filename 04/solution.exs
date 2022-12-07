defmodule Solution do
  def part1() do
    input()
      |> Enum.map(&total_overlap/1)
      |> Enum.sum
  end

  def part2() do
    input()
      |> Enum.map(&overlap/1)
      |> Enum.sum
  end
  
  defp input() do
    File.stream!("04/input.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_ranges/1)
  end
  
  defp parse_ranges(line) do
    line
      |> String.split([",", "-"])
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
  end
  
  defp total_overlap([[x1, y1], [x2, y2]]) do
    # Either the first pair is contained within the second
    # or the second is contained within the first.
    overlap_12 = x1 >= x2 and y1 <= y2
    overlap_21 = x2 >= x1 and y2 <= y1
    if overlap_12 or overlap_21, do: 1, else: 0
  end
  
  defp overlap([[x1, y1], [x2, y2]]) do
    # Either the first pair's start is within the second pair
    # or the second pair's start is within the first pair.
    overlap_12 = x1 >= x2 and x1 <= y2
    overlap_21 = x2 >= x1 and x2 <= y1
    if overlap_12 or overlap_21, do: 1, else: 0
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"