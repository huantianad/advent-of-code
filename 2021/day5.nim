include aoc
import strscans

type
  Line = tuple
    success: bool
    x1, y1, x2, y2: int

  Point = tuple
    x, y: int

let testInput = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2""".splitLines

iterator betterCounter(a, b: int): int =
  if a < b:
    for x in countup(a, b):
      yield x
  else:
    for x in countdown(a, b):
      yield x

day 5:
  part 1:
    let parsedLines: seq[Line] = collect:
      for line in lines:
        line.scanTuple("$i,$i -> $i,$i")

    var counter = initCountTable[Point]()

    for line in parsedLines:
      var points: seq[Point]

      if line.x1 == line.x2:
        points = collect:
          for y in betterCounter(line.y1, line.y2):
            (line.x1, y)

      elif line.y1 == line.y2:
        points = collect:
          for x in betterCounter(line.x1, line.x2):
            (x, line.y1)

      else:
        points = zip(betterCounter(line.x1, line.x2).toseq, betterCounter(line.y1, line.y2).toseq)

      echo points

      for point in points:
        counter.inc point


    var count: int
    for point, times in counter.pairs:
      if times > 1:
        inc count

    count
  part 2:
    "Part 2 solution"
