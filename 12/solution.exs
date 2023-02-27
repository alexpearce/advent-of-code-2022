defmodule Solution do
  @doc """
  # Idea

  1. Find the starting position {x, y} marked 'S'.
  2. Call `shortest_path({x, y}, grid)` which returns a map of points
     to the shortest path found to the finishing position marked 'E'.
  3. `shortest_path/2` does a depth-first search from its first argument,
     only exploring directions whose character is at most one character away
     from the character at its argument (need to special case 'S').
     As it recurses it builds a map of positions to shortest paths.
  """
  def part1() do
    IO.puts "XXX"
    grid = input()
    start = find_character(grid, ?S)
    goal = find_character(grid, ?E)
    shortest_path(grid, start, goal)
  end

  def part2() do
  end

  defp input() do
    File.stream!("12/example.txt")
    # File.stream!("12/input.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {row, row_index}, acc ->
           row_map =
             row
             |> Enum.reduce(%{}, fn {element, column_index}, row_acc ->
                  Map.put(row_acc, {row_index, column_index}, :binary.first(element))
                end)
           Map.merge(acc, row_map)
         end)
  end

  defp find_character(grid, character) do
    {key, _} = grid
      |> Enum.find(fn {_, value} -> value == character end)
    key
  end

  defp shortest_path(grid, origin, goal) do
    {distance, _} = recurse(grid, origin, goal)
    distance
  end

  defp recurse(grid, origin, goal, distance \\ 0, visited \\ %{}) do
    # Character `S` has the same level as `a`.
    starting_character = if grid[origin] == ?S, do: ?a, else: grid[origin]
    cond do
      Map.has_key?(visited, origin) ->
        # We've been down this road higher up in the stack.
        {Map.get(visited, origin), visited}
      origin == goal ->
        {distance, visited}
      true ->
        # IO.inspect origin
        # Explore all valid neighbours and find the path to `goal` which minimises
        # the distance. If no path is found we record `:infinity`.
        nearby_characters = character_neighbours(starting_character)
        # We must reach the goal from the highest character `z`.
        allowed_characters = if starting_character == ?z, do: MapSet.put(nearby_characters, ?E), else: nearby_characters
        {distances, visited} = origin
          |> coordinate_neighbours
          |> Enum.filter(fn coord -> MapSet.member?(allowed_characters, Map.get(grid, coord)) end)
          # The `Map.put` prevents backtracking during the recursion
          |> Enum.map_reduce(Map.put(visited, origin, :infinity), fn coord, acc ->
            {d, v} = recurse(grid, coord, goal, distance + 1, acc)
            if origin == {0, 0}, do: IO.inspect {coord, v}
            {d, Map.merge(v, Map.put(acc, coord, d), fn _k, v1, v2 -> Enum.min([v1, v2]) end)}
          end)
        {Enum.min(distances), visited}
    end
  end

  defp character_neighbours(ascii_codepoint) do
    -1..1
      |> Enum.map(fn diff -> ascii_codepoint + diff end)
      |> MapSet.new
  end

  defp coordinate_neighbours({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
    ]
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"