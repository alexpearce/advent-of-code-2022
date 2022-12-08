defmodule Solution do
  def part1() do
    first_post_marker_index(4)
  end

  def part2() do
    first_post_marker_index(14)
  end
  
  defp first_post_marker_index(chunk_size) do
    # Return the index of the first character which appears
    # after a contiguous sequence of unique characters of
    # length `chunk_size`.
    index = input()
      |> String.graphemes
      |> Enum.chunk_every(chunk_size, 1)
      |> Enum.map(&unique_characters?/1)
      |> Enum.find_index(fn x -> x end)
    index + chunk_size
  end
  
  defp input() do
    [head | _ ] =
      File.stream!("06/input.txt")
        |> Enum.map(&String.trim/1)
    head
  end
  
  defp unique_characters?(characters) do
    # Return true if the list of characters contains no duplicates.
    Enum.count(MapSet.new(characters)) == Enum.count(characters)
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"