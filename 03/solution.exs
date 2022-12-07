defmodule Solution do
  @doc """
  
  ## Part 1
  
  Strategy:
  
  1. Partition each line into two equally-sized sets.
  2. Take the intersection of the two sets.
  
  It's a bit wasteful to form two sets; only one is required
  and the second half of the string can be compared character-wise
  to the set.
  
  ## Part 2
  
  Strategy:
  
  1. Chunk the input into groups of three lines.
  2. For each chunk, form one set per line and take the intersection
     of all three sets.
  """
  def part1() do
    input()
      |> Enum.map(&find_common_character/1)
      |> Enum.map(&character_to_priority/1)
      |> Enum.sum
  end

  def part2() do
    input()
      |> Enum.chunk_every(3)
      |> Enum.map(&find_common_character/1)
      |> Enum.map(&character_to_priority/1)
      |> Enum.sum
  end
  
  defp input() do
    File.stream!("03/input.txt")
      |> Enum.map(&String.trim/1)
  end
  
  defp find_common_character(line) when is_binary(line) do
    n_characters = String.length(line)
    set_size = Integer.floor_div(n_characters, 2)
    left = String.slice(line, 0, set_size)
    right = String.slice(line, set_size, n_characters)
    find_common_character([left, right])
  end
  
  defp find_common_character(lines) when is_list(lines) do
    [duplicate] = lines
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.to_list
    duplicate
  end
  
  defp character_to_priority(<<character>>) do
    # Take advantage of characters a..z and A..Z having
    # contiguous sequences as codepoints.
    cond do
      # a..z are encoded as 1..26.
      character in ?a..?z ->
        1 + character - ?a
      # A..Z are encoded as 27..52.
      character in ?A..?Z ->
        27 + character - ?A
    end
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"