from collections import deque


def locate(grid, character):
    for idx in range(len(grid)):
        for jdx in range(len(grid[idx])):
            if grid[idx][jdx] == character:
                return (idx, jdx)
    return None


def neighbours(grid, pos):
    x, y = pos
    character = grid[x][y]
    ordinal = ord(character)
    allowed = {chr(ordinal - 1), character, chr(ordinal + 1)}
    if character == "S":
        allowed.add("a")
    if character == "z":
        allowed.add("E")
    positions = []
    for xdiff in [-1, 1]:
        try:
            if x + xdiff >= 0 and grid[x + xdiff][y] in allowed:
                positions.append((x + xdiff, y))
        except IndexError:
            pass
    for ydiff in [-1, 1]:
        try:
            if y + ydiff >= 0 and grid[x][y + ydiff] in allowed:
                positions.append((x, y + ydiff))
        except IndexError:
            pass
    # print(positions)
    return positions


def bfs(grid, start, end):
    depth = 0
    frontier = deque([(depth, start)])
    visited = set()
    while frontier:
        depth, pos = frontier.popleft()
        # print(depth, pos)
        if pos == end:
            return depth
        for neighbour in neighbours(grid, pos):
            if neighbour not in visited and neighbour not in frontier:
                # print(f"Adding {neighbour}")
                frontier.append((depth + 1, neighbour))
            # else:
            #     print(f"Rejected {neighbour}")
        visited.add(pos)
    return None


with open("12/input.txt") as f:
    lines = f.readlines()
grid = [list(l.strip()) for l in lines]
distance = bfs(grid, locate(grid, "S"), locate(grid, "E"))
print(distance)