defmodule Solution do
  defmodule Node do
    defstruct [directories: MapSet.new, files: MapSet.new]
  end

  def part1() do
    %{nodes: nodes} = input()
      |> Enum.reduce(%{pwd: [], nodes: %{}}, &process/2)
    directory_size("/", nodes)
      |> Map.values
      |> Enum.reject(fn size -> size > 100_000 end)
      |> Enum.sum
  end

  def part2() do
    %{nodes: nodes} = input()
      |> Enum.reduce(%{pwd: [], nodes: %{}}, &process/2)
    directory_sizes = directory_size("/", nodes)
    used = directory_sizes["/"]
    available = 70_000_000
    free = available - used
    need_to_free = 30_000_000 - free
    # Find the smallest directory whose size is at least as great
    # as the space we need to free
    directory_sizes
      |> Map.values
      |> Enum.reject(fn size -> size < need_to_free end)
      |> Enum.min
  end

  defp input() do
    File.stream!("07/input.txt")
      |> Enum.map(&String.trim/1)
  end

  defp process("$ cd ..", %{pwd: [_ | new_pwd]} = state), do: %{state | pwd: new_pwd}
  defp process(<<"$ cd ", dirname::binary>>, %{pwd: pwd, nodes: nodes} = state) do
    pwd = if dirname == "/", do: ["/"], else: [dirname | pwd]
    path = pwd_to_path(pwd)
    node = Map.get(nodes, path, %Node{})
    %{state | pwd: pwd, nodes: Map.put(nodes, path, node)}
  end
  defp process("$ ls", state), do: state
  defp process(<<"dir ", dirname::binary>>, %{pwd: pwd, nodes: nodes} = state) do
    path = pwd_to_path(pwd)
    node = Map.fetch!(nodes, path)
    node = %Node{node | directories: MapSet.put(node.directories, dirname)}
    %{state | nodes: Map.put(nodes, path, node)}
  end
  defp process(line, %{pwd: pwd, nodes: nodes} = state) do
    path = pwd_to_path(pwd)
    node = Map.fetch!(nodes, path)
    [size, name] = String.split(line, " ")
    node = %Node{node | files: MapSet.put(node.files, {name, String.to_integer(size)})}
    %{state | nodes: Map.put(nodes, path, node)}
  end

  defp directory_size(root, directories) do
    directory = directories[root]
    size_from_files =
      directory.files
      |> Enum.map(fn {_, size} -> size end)
      |> Enum.sum
    prefix =
      case root do
        "/" -> "/"
        r -> r <> "/"
      end
    # Compute the size of each descendent directory
    descendent_sizes =
      directory.directories
      |> Enum.map(&(directory_size(prefix <> &1, directories)))
      |> Enum.reduce(%{}, &Map.merge/2)
    # Compute the total size of all direct descendents
    size_from_children =
      directory.directories
      |> Enum.map(&(Map.fetch!(descendent_sizes, prefix <> &1)))
      |> Enum.sum
    total = size_from_files + size_from_children
    Map.put(descendent_sizes, root, total)
  end

  defp pwd_to_path([root]), do: root
  defp pwd_to_path(pwd) do
    <<"/", path::binary>> =
      pwd
      |> Enum.reverse
      |> Enum.join("/")
    path
  end
end

IO.puts "Part 1: #{Solution.part1}"
IO.puts "Part 2: #{Solution.part2}"