include aoc

type
  Point = tuple
    x, y: int

  Fold = tuple
    axis: char
    position: int

day 13:
  [rawPoints, rawFolds] <- input.split("\n\n")

  let points: HashSet[Point] = collect:
    for rawPoint in rawPoints.splitLines.toSeq:
      let (success, x, y) = rawPoint.scanTuple("$i,$i")
      if success: {(x, y)}

  let folds: seq[Fold] = collect:
    for rawFold in rawFolds.splitLines:
      let (success, axis, position) = rawFold.scanTuple("fold along $c=$i")
      if success: (axis, position)

  var stages: seq[HashSet[Point]] = @[points]
  for axis, position in folds.items:
    stages.add collect(
      if axis == 'x':
        for point in stages[^1]:
          if point.x > position: (position * 2 - point.x, point.y)
          else: point
      elif axis == 'y':
        for point in stages[^1]:
          if point.y > position: (point.x, position * 2 - point.y)
          else: point
    ).toHashSet


  var final = ""
  let xMax = stages[^1].mapIt(it.x).max
  let yMax = stages[^1].mapIt(it.y).max

  for y in 0..yMax:
    final &= "\n"
    for x in 0..xMax:
      if (x, y) in stages[^1]:
        final &= "#"
      else:
        final &= " "

  part 1:
    stages[1].len
  part 2:
    final
