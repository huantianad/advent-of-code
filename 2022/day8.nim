include aoc

type Grid = seq[seq[int]]

proc calcScore(grid: Grid, x, y: int): tuple[score: int, visible: bool] =
  var cleanSweeps = 4
  result.score = 1

  template brr(grid: Grid, iter, exp: untyped) =
    var i: int
    for it in iter:
      inc i
      let it {.inject.} = it
      if exp >= grid[x][y]:
        cleanSweeps -= 1
        break
    result.score *= i

  grid.brr(countdown(x - 1, grid.low), grid[it][y])
  grid.brr(countup(x + 1, grid.high), grid[it][y])
  grid.brr(countdown(y - 1, grid.low), grid[x][it])
  grid.brr(countup(y + 1, grid.high), grid[x][it])

  result.visible = cleanSweeps > 0

day 8:
  let grid = collect:
    for line in lines: collect:
      for c in line:
        parseInt($c)

  let processed = collect:
    for x in 0..grid.high:
      for y in 0..grid.high:
        grid.calcScore(x, y)

  part 1:
    processed.countIt(it.visible)
  part 2:
    processed.mapIt(it.score).max()