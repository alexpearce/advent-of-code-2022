defmodule Solution do
  def part1() do
  end

  def part2() do
  end

  defp input() do
    File.stream!("00/input.txt")
      |> Enum.map(&String.trim/1)
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"