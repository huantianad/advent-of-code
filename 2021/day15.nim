include aoc

type
  Point = tuple
    x, y: int

  Board = seq[seq[int]]

proc toBoard(raw: string): Board =
  raw.splitLines.mapIt(it.toSeq.mapIt(($it).parseInt))

proc `$`(board: Board): string =
  board.mapIt(it.join).join("\n")

template `[]`(board: Board, key: Point): int =
  board[key.y][key.x]

proc `[]=`(board: var Board, key: Point, value: int) =
  board[key.y][key.x] = value

iterator points(board: Board): Point =
  for y in 0..<board.len:
    for x in 0..<board[0].len:
      yield (x, y)

iterator neighbors(point: Point): Point =
  for x, y in directions4.items:
    yield (point.x + x, point.y + y)

iterator neighbors(board: Board, point: Point): Point =
  for x, y in point.neighbors:
    if 0 <= x and x < board[0].len and 0 <= y and y < board.len:
      yield (x, y)

proc findRisk(inputBoard: Board): int =
  var board = inputBoard
  board[(0, 0)] = 0

  var counter: int
  var visited: HashSet[Point] = [(0, 0)].toHashSet
  var current: HashSet[Point] = [(0, 0)].toHashSet

  while true:
    var newVisited = visited
    var newCurrent = current

    for point in current:
      if point == (board.len - 1, board[0].len - 1):
        return counter + board[point]

      if board[point] == 0:
        newCurrent.excl(point)
        for neighbor in board.neighbors(point):
          if neighbor notin newVisited:
            newVisited.incl(neighbor)
            newCurrent.incl(neighbor)
            board[neighbor] -= 1
      else:
        board[point] -= 1

    counter.inc
    visited = newVisited
    current = newCurrent

iterator diagonalIndexes(): (int, seq[Point]) =
  for i in 0..<9:
    yield (i, collect(
      for x in max(0, i - 4)..min(4, i):
        (x, i - x)
    ))

proc tileBoard(inputBoard: Board): Board =
  let size = inputBoard.len
  result = newSeqWith(size * 5, newSeq[int](size * 5))

  for added, bigIndexes in diagonalIndexes():
    for bigIndex in bigIndexes:
      for point in inputBoard.points:
        let newPoint: Point = (point.x + size * bigIndex.x, point.y + size * bigIndex.y)
        result[newPoint] = (inputBoard[point] + added) mod 9
        if result[newPoint] == 0:
          result[newPoint] = 9


day 15:
  part 1:
    findRisk(input.toBoard)
  part 2:
    findRisk(input.toBoard.tileBoard)
