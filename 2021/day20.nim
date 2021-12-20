include aoc

type
  Point = tuple
    x, y: int

  Image = object of RootObj
    board: Table[Point, bool]
    isVoidFlipped: bool


func pretty(image: Image): string =
  let board = image.board
  let xMax = board.keys.toSeq.mapIt(it.x).max
  let xMin = board.keys.toSeq.mapIt(it.x).min
  let yMax = board.keys.toSeq.mapIt(it.y).max
  let yMin = board.keys.toSeq.mapIt(it.y).min

  for y in countdown(yMax, yMin):
    result &= "\n"
    for x in xMin..xMax:
      if board.getOrDefault((x, y), image.isVoidFlipped):
        result &= "#"
      else:
        result &= "."

func toNumChar(input: bool): char =
  if input: '1' else: '0'

iterator neighborsSelf(point: Point): Point =
  const dirSelf = [(-1, 1), (0, 1), (1, 1), (-1, 0), (0, 0), (1, 0), (-1, -1), (0, -1), (1, -1)]
  for x, y in dirSelf.items:
    yield (point.x + x, point.y + y)

func pixelNeighborValue(point: Point, image: Image): int =
  let binString = collect:
    for neighbor in point.neighborsSelf:
      if neighbor in image.board:
        image.board[neighbor].toNumChar
      else:
        image.isVoidFlipped.toNumChar

  binString.join.parseBinInt

func enhance(image: Image, alg: string): Image =
  let possiblePoints = collect:
    for point, isLit in image.board:
      for neighbor in point.neighborsSelf:
        {neighbor}

  for point in possiblePoints:
    let value = pixelNeighborValue(point, image)
    result.board[point] = alg[value] == '#'

  if alg[0] == '#':
    result.isVoidFlipped = not image.isVoidFlipped

func repeat[T](input: T, f: T -> T, times: int): T =
  if times == 0:
    input
  else:
    repeat(f(input), f, times - 1)


day 20:
  [alg, rawImage] <- input.split("\n\n")

  let board = collect:
    for lineNum, line in rawImage.splitLines.toSeq.reversed.pairs:
      for colNum, pixel in line:
        {(x: colNum, y: lineNum): pixel == '#'}

  let image = Image(board: board)

  part 1:
    image.repeat(x => x.enhance(alg), 2).board.values.countIt(it)
  part 2:
    image.repeat(x => x.enhance(alg), 50).board.values.countIt(it)
