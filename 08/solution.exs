defmodule Solution do
  def part1() do
    forest = input()
    # Scan along each row in each direction
    west_to_east =
      forest
      |> Enum.map(&scan_visibility/1)
    east_to_west =
      forest
      |> reverse_rows
      |> Enum.map(&scan_visibility/1)
      |> reverse_rows
    # Scan along each column in each direction
    north_to_south =
      forest
      |> transpose_rows
      |> Enum.map(&scan_visibility/1)
      |> transpose_rows
    south_to_north =
      forest
      |> transpose_rows
      |> reverse_rows
      |> Enum.map(&scan_visibility/1)
      |> reverse_rows
      |> transpose_rows
    # Merge results as the `or` of the elements at each position,
    # then
    List.zip([west_to_east, east_to_west, north_to_south, south_to_north])
      |> Enum.flat_map(fn {a, b, c, d} ->
           List.zip([a, b, c, d])
             |> Enum.map(fn {i, j, k, l} -> i or j or k or l end)
         end)
      |> Enum.map(fn x -> if x, do: 1, else: 0 end)
      |> Enum.sum
  end

  def part2() do
  end

  defp input() do
    File.stream!("08/input.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp scan_visibility(trees) do
    %{result: result} = trees
      |> Enum.reduce(%{max: -1, result: []}, &scan_visibility/2)
    Enum.reverse(result)
  end
  defp scan_visibility(tree, %{max: max, result: result}) do
    result = [tree > max | result]
    max = Enum.max([tree, max])
    %{max: max, result: result}
  end

  def reverse_rows(rows) do
    rows
      |> Enum.map(&Enum.reverse/1)
  end

  defp transpose_rows(rows) do
    rows
      |> List.zip
      |> Enum.map(&Tuple.to_list/1)
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"