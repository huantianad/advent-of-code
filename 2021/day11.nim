include aoc

type
  Point = tuple
    x, y: int

  Board = seq[seq[int]]

proc `$`(board: Board): string =
  board.mapIt(it.join).join("\n")

template `[]`(board: Board, key: Point): int =
  board[key.y][key.x]

proc `[]=`(board: var Board, key: Point, val: int) =
  board[key.y][key.x] = val

iterator points(board: Board): Point =
  for y in 0..<board.len:
    for x in 0..<board[0].len:
      yield (x, y)

iterator neighbors(point: Point): Point =
  for x, y in directions8.items:
    yield (point.x + x, point.y + y)

iterator neighbors(board: Board, point: Point): Point =
  for x, y in point.neighbors:
    if 0 <= x and x < board[0].len and 0 <= y and y < board.len:
      yield (x, y)

proc notDone(board: Board, flashed: HashSet[Point]): bool =
  # True whenever there's a point that could flash, but hasn't yet.
  for point in board.points:
    if board[point] > 9 and point notin flashed:
      return true

proc notAllSame(board: Board): bool =
  let first = board[0][0]
  for point in board.points:
    if board[point] != first:
      return true

day 11:
  var board: Board = lines.mapIt(it.toSeq.mapIt(($it).parseInt))

  var flashes: int
  var turns: int

  while board.notAllSame:
    for point in board.points:
      board[point] += 1

    var flashed = initHashSet[Point]()
    while board.notDone(flashed):
      for point in board.points:
        if board[point] > 9 and point notin flashed:
          flashed.incl(point)
          if turns < 100: flashes += 1

          for neighbor in board.neighbors(point):
            board[neighbor] += 1

    for point in flashed:
      board[point] = 0

    turns += 1

  part 1:
    flashes
  part 2:
    turns