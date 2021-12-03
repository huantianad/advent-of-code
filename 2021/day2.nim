include aoc

day 2:
  var x, y, depth: int

  for line in lines:
    [command, magString] <- line.split(" ")
    let mag = magString.parseInt

    case command:
    of "up": y -= mag
    of "down": y += mag
    of "forward":
      x += mag
      depth += y * mag

  part 1: x * y
  part 2: x * depth
