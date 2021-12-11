include aoc

type
  Point = tuple
    x, y: int

  Board = seq[seq[int]]

proc `$`(board: Board): string =
  board.mapIt(it.join).join("\n")

template `[]`(board: Board, point: Point): int =
  board[point.y][point.x]

proc `[]=`(board: var Board, key: Point, val: int) =
  board[key.y][key.x] = val

iterator points(board: Board): Point =
  for y, row in board.pairs:
    for x, col in row.pairs:
      yield (x, y)

iterator neighbors(point: Point): Point =
  for x, y in directions8.items:
    yield (point.x + x, point.y + y)

iterator neighbors(board: Board, point: Point): Point =
  for x, y in point.neighbors:
    if 0 <= x and x < board[0].len and 0 <= y and y < board.len:
      yield (x, y)

iterator neighborValues(board: Board, point: Point): int =
  for point in board.neighbors(point):
    yield board[point]

proc notDone(board: Board, flashed: seq[Point]): bool =
  for y, row in board.pairs:
    for x, value in row.pairs:
      if value > 9 and (x, y) notin flashed:
        return true
  return false


let test = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526""".splitLInes


day 11:
  var board: Board = lines.mapIt(it.toSeq.mapIt(($it).parseInt))

  var counter: int

  for _ in 1..100:
    for point in board.points:
      board[point] += 1

    var flashed: seq[Point]
    while board.notDone(flashed):
      for point in board.points:
        if board[point] > 9 and point notin flashed:
          counter.inc
          flashed.add(point)

          for neighbor in board.neighbors(point):
            board[neighbor] += 1

    for point in flashed:
      board[point] = 0

    echo board

  part 1:
    counter
  part 2:
    "Part 2 solution"