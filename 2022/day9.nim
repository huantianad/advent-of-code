include aoc

proc `+`(a, b: (int, int)): (int, int) =
  (a[0] + b[0], a[1] + b[1])

proc `+=`(a: var (int, int), b: (int, int)) =
  a[0] += b[0]
  a[1] += b[1]

proc `-`(a, b: (int, int)): (int, int) =
  (a[0] - b[0], a[1] - b[1])

proc areNotAdj(a, b: (int, int)): bool =
  abs(a[0] - b[0]) > 1 or abs(a[1] - b[1]) > 1

proc dirToPos(c: char): (int, int) =
  case c:
  of 'U': (0, 1)
  of 'D': (0, -1)
  of 'L': (-1, 0)
  of 'R': (1, 0)
  else: assert false; (0, 0)

var test = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2""".splitLines()

day 9:
  let instructions = collect:
    for line in lines:
      let (success, dir, steps) = line.scanTuple("$c $i")
      assert success
      (dir, steps)

  var currentHead = (0, 0)
  var currentTail = (0, 0)
  var visited = [(0, 0)].toHashSet

  for (dir, steps) in instructions:
    for _ in 1..steps:
      if currentTail.areNotAdj(currentHead + dir.dirToPos):
        visited.incl currentHead
        currentTail = currentHead

      currentHead += dir.dirToPos

  print visited

  part 1:
    visited.len
  part 2:
    "Part 2 solution"