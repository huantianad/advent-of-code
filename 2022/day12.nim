include aoc
import std/enumerate

type
  Pos = (int, int)
  Grid = seq[seq[1..26]]

proc `+`(a, b: Pos): Pos =
  (a[0] + b[0], a[1] + b[1])

proc `[]`(grid: Grid, pos: Pos): 1..26 =
  grid[pos[1]][pos[0]]

proc contains(grid: Grid, pos: Pos): bool =
  pos[0] in grid[0].low..grid[0].high and pos[1] in grid.low..grid.high

iterator neighbors(grid: Grid, pos: Pos): Pos =
  for dir in directions4:
    if pos + dir in grid:
      yield pos + dir

proc parseInput(input: string): tuple[grid: Grid, start, finish: Pos] =
  result.grid = collect:
    for y, line in enumerate(input.splitLines()):
      collect:
        for x, c in enumerate(line):
          if c == 'S':
            result.start = (x, y)
            range[1..26](1)
          elif c == 'E':
            result.finish = (x, y)
            range[1..26](26)
          else:
            range[1..26](c.ord - 'a'.ord + 1)

proc run(grid: Grid, start, finish: Pos): int =
  var edges = [start].toHashSet()
  var visited = [start].toHashSet()
  while true:
    inc result
    var newEdges = initHashSet[Pos]()
    for current in edges:
      for next in neighbors(grid, current):
        if next notin visited and grid[next] <= grid[current] + 1:
          visited.incl next
          newEdges.incl next
          if next == finish: return
    edges = newEdges

proc run2(grid: Grid, finish: Pos): int =
  var edges = [finish].toHashSet()
  var visited = [finish].toHashSet()
  while true:
    inc result
    var newEdges = initHashSet[Pos]()
    for current in edges:
      for next in neighbors(grid, current):
        if next notin visited and grid[current] <= grid[next] + 1:
          visited.incl next
          newEdges.incl next
          if grid[next] == 1: return
    edges = newEdges

day 12:
  let (grid, start, finish) = input.parseInput()

  part 1:
    run(grid, start, finish)

  part 2:
    run2(grid, finish)
