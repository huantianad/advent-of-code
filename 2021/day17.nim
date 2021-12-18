include aoc

type
  Point = tuple
    x, y: int

  TargetRegion = tuple
    xMin, xMax, yMin, yMax: int

proc `+=`(base: var Point, value: Point) =
  base.x += value.x
  base.y += value.y

func dirToZero(input: int): int =
  if input > 0: -1
  elif input < 0: 1
  else: 0

func simulate(initialVelocity: Point, target: TargetRegion): (bool, int) =
  var velocity = initialVelocity
  var location: Point = (0, 0)
  var maxY = int.low

  while true:
    location += velocity
    velocity += (velocity.x.dirToZero, -1)

    if location.y > maxY: maxY = location.y

    if target.xMin <= location.x and location.x <= target.xMax and
      target.yMin <= location.y and location.y <= target.yMax:
      return (true, maxY)

    if location.x > target.xMax or location.y < target.yMin:
      return (false, maxY)


day 17:
  let (_, xMin, xMax, yMin, yMax) = input.scanTuple("target area: x=$i..$i, y=$i..$i")
  let target: TargetRegion = (xMin, xMax, yMin, yMax)

  let x0Min = int(0.5*sqrt(float(8*xMin+1))-0.5)

  let maxYValues = collect:
    for y0 in countdown(1000, yMin):
      for x0 in x0Min..xMax:
        let (success, pathMaxY) = simulate((x0, y0), target)
        # if success: echo (x0, y0)
        if success: pathMaxY

  part 1:
    maxYValues.max
  part 2:
    maxYValues.len
