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

proc notDone(board: Board, flashed: seq[Point]): bool =
  for point in board.points:
    if board[point] > 9 and point notin flashed:
      return true
  return false

proc allSame(board: Board): bool =
  let first = board[0][0]
  for point in board.points:
    if board[point] != first: return false
  return true


day 11:
  var board: Board = lines.mapIt(it.toSeq.mapIt(($it).parseInt))

  var counter1: int
  var counter2: int

  while not board.allSame:
    for point in board.points:
      board[point] += 1

    var flashed: seq[Point]
    while board.notDone(flashed):
      for point in board.points:
        if board[point] > 9 and point notin flashed:
          if counter2 < 100: counter1.inc
          flashed.add(point)

          for neighbor in board.neighbors(point):
            board[neighbor] += 1

    for point in flashed:
      board[point] = 0

    inc counter2

  part 1:
    counter1
  part 2:
    counter2