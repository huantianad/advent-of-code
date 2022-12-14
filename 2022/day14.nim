include aoc

type Pos = (int, int)

proc `+`(a, b: Pos): Pos =
  (a[0] + b[0], a[1] + b[1])

proc `+=`(a: var Pos, b: Pos) =
  a[0] += b[0]
  a[1] += b[1]

iterator rangey(a, b: int): int =
  if a < b:
    for i in a..b:
      yield i
  else:
    for i in b..a:
      yield i

proc parseLine(input: string): seq[Pos] =
  for segment in input.split(" -> "):
    let (suc, x, y) = segment.scanTuple("$i,$i")
    assert suc
    result.add (x, y)

proc parseInput(input: string): HashSet[Pos] =
  for line in input.splitLines():
    let segments = line.parseLine()
    for i in 0..<segments.high:
      let a = segments[i]
      let b = segments[i + 1]
      for x in rangey(a[0], b[0]):
        for y in rangey(a[1], b[1]):
          result.incl (x, y)

proc maxHeight(grid: HashSet[Pos]): Natural =
  for elem in grid:
    if elem[1] > result:
      result = elem[1]

proc moveSand(grid: var HashSet[Pos], sand: var Pos, maxHeight: Natural): bool =
  if sand[1] + 1 == maxHeight:
    return true

  if sand + (0, 1) notin grid:
    sand += (0, 1)
  elif sand + (-1, 1) notin grid:
    sand += (-1, 1)
  elif sand + (1, 1) notin grid:
    sand += (1, 1)
  else:
    return true


const test = """498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"""

day 14:
  let parsed = input.parseInput()
  let maxHeight = parsed.maxHeight()

  # part 1:
  #   var grid = parsed
  #   result = 0

  #   while true:
  #     var sand = (500, 0)

  #     while not grid.moveSand(sand, maxHeight):
  #       discard

  #     if sand[1] >= maxHeight:
  #       return

  #     inc result
  #     grid.incl sand

  part 2:
    var grid = parsed
    result = 0

    while true:
      if (500, 0) in grid:
        return

      var sand = (500, 0)

      while not grid.moveSand(sand, maxHeight + 2):
        discard

      inc result
      grid.incl sand
