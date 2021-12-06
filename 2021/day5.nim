include aoc

type
  Line = tuple
    success: bool
    x1, y1, x2, y2: int

  Point = tuple
    x, y: int

iterator betterCounter(a, b: int): int =
  for x in countup(a, b):
    yield x
  for x in countdown(a, b):
    yield x

day 5:
  let parsedLines: seq[Line] = collect:
    for line in lines:
      line.scanTuple("$i,$i -> $i,$i")

  var straight = initCountTable[Point]()
  var diagonal = initCountTable[Point]()

  for line in parsedLines:
    if line.x1 == line.x2:
      for y in betterCounter(line.y1, line.y2):
        straight.inc (line.x1, y)

    elif line.y1 == line.y2:
      for x in betterCounter(line.x1, line.x2):
        straight.inc (x, line.y1)

    else:
      let points = zip(
        betterCounter(line.x1, line.x2).toseq,
        betterCounter(line.y1, line.y2).toseq
      )

      for point in points:
        diagonal.inc point

  part 1:
    straight.values.countIt(it > 1)
  part 2:
    var all = straight
    all.merge(diagonal)

    all.values.countIt(it > 1)
