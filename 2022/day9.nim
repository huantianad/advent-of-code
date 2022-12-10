include aoc
import std/decls

type Pos = (int, int)

proc `+`(a, b: Pos): Pos =
  (a[0] + b[0], a[1] + b[1])

proc `+=`(a: var Pos, b: Pos) =
  a[0] += b[0]
  a[1] += b[1]

proc `-`(a, b: Pos): Pos =
  (a[0] - b[0], a[1] - b[1])

proc areNotAdj(a, b: Pos): bool =
  abs(a[0] - b[0]) > 1 or abs(a[1] - b[1]) > 1

func norm*(v: Pos): Pos =
  result[0] =
    if v[0] == 0:
      0
    else:
      v[0] div v[0].abs
  result[1] =
    if v[1] == 0:
      0
    else:
      v[1] div v[1].abs

proc dirToPos(c: char): Pos =
  case c:
  of 'U': (0, 1)
  of 'D': (0, -1)
  of 'L': (-1, 0)
  of 'R': (1, 0)
  else: assert false; (0, 0)

proc solve(len: static int, instructions: seq[(char, int)]): int =
  var positions: array[0..len, Pos]
  var visited = [(0, 0)].toHashSet

  for (dir, steps) in instructions:
    for _ in 1..steps:
      positions[0] += dir.dirToPos

      for i in 0..<len:
        var currentHead {.byaddr.} = positions[i]
        var currentTail {.byaddr.} = positions[i + 1]

        if currentTail.areNotAdj(currentHead):
          currentTail += (currentHead - currentTail).norm

      visited.incl positions[^1]

  visited.len

day 9:
  let instructions = collect:
    for line in lines:
      let (success, dir, steps) = line.scanTuple("$c $i")
      assert success
      (dir, steps)

  part 1:
    solve(1, instructions)
  part 2:
    solve(9, instructions)