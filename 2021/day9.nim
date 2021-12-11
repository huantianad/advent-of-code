include aoc

type
  Point = tuple
    x, y: int

  Board = seq[seq[int]]


proc get(board: Board, point: Point): int =
  board[point.y][point.x]

iterator points(board: Board): Point =
  for y, row in board.pairs:
    for x, col in row.pairs:
      yield (x, y)

iterator neighbors(point: Point): Point =
  for x, y in directions4.items:
    yield (point.x + x, point.y + y)

iterator neighbors(board: Board, point: Point): Point =
  for x, y in point.neighbors:
    if 0 <= x and x < board[0].len and 0 <= y and y < board.len:
      yield (x, y)

iterator neighborValues(board: Board, point: Point): int =
  for point in board.neighbors(point):
    yield board.get(point)

proc isLow(board: Board, point: Point): bool =
  for neighbor in board.neighborValues(point):
    if neighbor <= board.get(point):
      return false

  return true

proc search(board: Board, point: Point, visited: var seq[Point]): int =
  visited.add(point)

  for neighbor in board.neighbors(point):
    if neighbor in visited: continue
    if board.get(neighbor) == 9: continue

    result += search(board, neighbor, visited)

  # Increment the counter for this point
  result.inc

proc search(board: Board, point: Point): int =
  var visited: seq[Point]

  search(board, point, visited)


day 9:
  let board: Board = lines.mapIt(it.toSeq.mapIt(($it).parseInt))

  let lowPoints = board.points.toSeq.filterIt(board.isLow(it))

  let part1 = lowPoints.mapIt(board.get(it)).sum + lowPoints.len
  let part2 = lowPoints.mapIt(search(board, it)).sorted(SortOrder.Descending)

  part 1:
    part1
  part 2:
    part2[0] * part2[1] * part2[2]
