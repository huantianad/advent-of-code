include aoc

type
  Point = tuple
    x, y: int

  Fold = tuple
    axis: char
    position: int

day 13:
  var points: HashSet[Point]
  var folds: seq[Fold]

  for line in lines:
    let (success, x, y) = line.scanTuple("$i,$i")
    if success: points.incl((x, y)); continue

    let (success2, axis, position) = line.scanTuple("fold along $c=$i")
    if success2: folds.add((axis, position))


  var stages: seq[HashSet[Point]] = @[points]
  for axis, position in folds.items:
    stages.add collect(
      for point in stages[^1]:
        if axis == 'x' and point.x > position: (position * 2 - point.x, point.y)
        elif axis == 'y' and point.y > position: (point.x, position * 2 - point.y)
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
