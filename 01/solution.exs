defmodule Solution do
  @moduledoc """ 
  Chunk the input into groups, using the empty line as the separator.
  Return the group with the largest sum.
  """

  @doc """
  Return the sum of calories held by each elf.
  """
  def elf_calories() do
    stream = File.stream!("01/input.txt")
    chunk_fun = fn element, acc ->
      if element == "\n" do
        # Emit the accumlator as a chunk, ignoring the current element.
        {:cont, acc, []}
      else
        # Convert the element to an integer and add it to the accumulator.
        {:cont, [String.to_integer(String.trim(element)) | acc]}
      end
    end
    after_fun = fn
      # Do not emit a chunk, e.g. if the final line is empty.
      [] -> {:cont, []}
      # Emit the final state of the accumulator as a chunk.
      acc -> {:cont, acc, []}
    end
    Enum.chunk_while(stream, [], chunk_fun, after_fun)
      |> Enum.map(&Enum.sum/1)
  end
  
  @doc """
  Return the largest number of calories held by a single elf.
  """
  def part1() do
    elf_calories()
      |> Enum.max
  end
  
  @doc """
  Return the sum of calories held by the top-three elves.
  """
  def part2() do
    elf_calories()
      |> Enum.sort
      |> Enum.take(-3)
      |> Enum.sum
  end
end

IO.puts "Max calories held by one elf: #{Solution.part1}"
IO.puts "Total calories held by top-three elves: #{Solution.part2}"