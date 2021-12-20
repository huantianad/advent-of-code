include aoc

type
  Point = tuple
    x, y, z: int

  Scanner = seq[Point]

proc `+`(a, b: Point): Point =
  (a.x + b.x, a.y + b.y, a.z + b.z)

proc `-`(a, b: Point): Point =
  (a.x - b.x, a.y - b.y, a.z - b.z)

proc distance(a, b: Point): int =
  let diff = a - b
  abs(diff.x) + abs(diff.y) + abs(diff.z)

proc rotate(point: Point, n: range[1..24]): Point =
  let (x, y, z) = point
  let rotations = [
    (x, z, -y), (-z, x, -y), (-x, -z, -y),
    (z, -x, -y), (z, -y, x), (y, z, x),
    (-z, y, x), (-y, -z, x), (-y, x, z),
    (-x, -y, z), (y, -x, z), (x, y, z),
    (-z, -x, y), (x, -z, y), (z, x, y),
    (-x, z, y), (-x, y, -z), (-y, -x, -z),
    (x, -y, -z), (y, x, -z), (y, -z, -x),
    (z, y, -x), (-y, z, -x), (-z, -y, -x)
  ]
  return rotations[n - 1]

day 19:
  let parsedScanners: seq[Scanner] = collect:
    for rawScanner in input.split("\n\n"): collect:
      for rawPoint in rawScanner.splitLines:
        let (success, x, y, z) = rawPoint.scanTuple("$i,$i,$i")
        if success: (x, y, z)

  var board = parsedScanners[0].toHashSet
  var scannerLocations = @[(0, 0, 0)]
  var remainingScanners = parsedScanners[1..^1].toDeque

  while remainingScanners.len != 0:
    let currentScanner = remainingScanners.popFirst
    block checkScanner:
      for boardPoint in board:
        for scannerPoint in currentScanner:
          for orientationNum in 1..24:
            let offset = boardPoint - scannerPoint.rotate(orientationNum)
            let transformed = currentScanner.mapIt(offset + it.rotate(orientationNum))
            if transformed.countIt(it in board) >= 12:
              board = board + transformed.toHashSet
              scannerLocations.add(offset)
              break checkScanner

      # If we got here, that means this scanner didn't have 12 matches, try again later
      remainingScanners.addLast(currentScanner)

  let distances = collect:
    for scanner1 in scannerLocations:
      for scanner2 in scannerLocations:
        distance(scanner1, scanner2)

  part 1:
    board.len
  part 2:
    distances.max
