include aoc

type Grid = seq[seq[int]]

proc isVisible(grid: Grid, x, y: int): bool =
  if all(collect(
    for x2 in 0..<x:
      grid[x][y] > grid[x2][y]
  ), x => x):
    return true

  if all(collect(
    for x2 in (x+1)..grid.high:
      grid[x][y] > grid[x2][y]
  ), x => x):
    return true

  if all(collect(
    for y2 in 0..<y:
      grid[x][y] > grid[x][y2]
  ), x => x):
    return true

  if all(collect(
    for y2 in (y+1)..grid.high:
      grid[x][y] > grid[x][y2]
  ), x => x):
    return true

day 8:
  let grid = collect:
    for line in lines:
      line.mapIt(parseInt($it))

  echo grid.len
  echo grid.len * grid.len

  part 1:
    result = 0
    for x in 0..grid.high:
      for y in 0..grid.high:
        if grid.isVisible(x, y):
          inc result
  part 2:
    "Part 2 solution"