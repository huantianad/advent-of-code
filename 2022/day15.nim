include aoc
import std/options

type Pos = tuple[x, y: int]

proc sliced(sensor, beacon: Pos, targetY: int): Option[Slice[int]] =
  let distance = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
  let relativeY = targetY - sensor.y
  if relativeY notin -distance..distance: return
  let remainingX = abs(distance - abs(relativeY))
  return ((sensor.x - remainingX)..(sensor.x + remainingX)).some

proc squish(a: Slice[int]): Slice[int] =
  max(0, a.a)..min(4000000, a.b)

proc intersectsWith(a, b: Slice[int]): bool =
  a.b >= b.a and a.a <= b.b

proc join(a, b: Slice[int]): Slice[int] =
  min(a.a, b.a)..max(a.b, b.b)

proc solve(parsed: seq[tuple[sensor, beacon: Pos]], targetY: int): Option[int] =
  var slices = collect(
    for (sensor, beacon) in parsed:
      let slice = sliced(sensor, beacon, targetY)
      if slice.isSome: slice.get().squish()
  ).toDeque()

  var lastLengthWasTwo: bool
  while slices.len > 1:
    let slice = slices.popLast()
    var success = false

    for i, other in slices:
      if slice.intersectsWith other:
        slices[i] = slice.join other
        success = true

    if not success:
      slices.addFirst slice

      if slices.len == 2 and lastLengthWasTwo:
        if slices[0].b < slices[1].a:
          assert slices[1].a - slices[0].b == 2
          return (targetY + (slices[0].b + 1) * 4000000).some
        elif slices[1].b < slices[0].a:
          assert slices[0].a - slices[1].b == 2
          return (targetY + (slices[1].b + 1) * 4000000).some
        else: assert false
      else:
        lastLengthWasTwo = slices.len == 2

day 15:
  let parsed = collect:
    for line in lines:
      let (suc, sx, sy, bx, by) = line.scanTuple("Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i")
      assert suc
      (sensor: (x: sx, y: sy), beacon: (x: bx, y: by))

  part 1:
    const targetY = 2000000

    var slices = collect(
      for (sensor, beacon) in parsed:
        let slice = sliced(sensor, beacon, targetY)
        if slice.isSome: slice.get()
    ).toDeque()

    while slices.len > 1:
      let slice = slices.popLast()
      for i, other in slices:
        if slice.intersectsWith other:
          slices[i] = slice.join other

    slices[0].b - slices[0].a

  part 2:
    for i in 0..4000000:
      let solution = solve(parsed, i)
      if solution.isSome:
        echo i
        return solution.get()