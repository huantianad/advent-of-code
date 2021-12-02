include aoc

day 1:
  part 1, int:
    var previous = 0
    var counter = 0

    for e in ints[1..^1]:
      if e > previous:
        counter += 1

      previous = e

    return counter

  part 2, int:
    var previous = 0
    var counter = 0

    for e in 1..(ints.len - 3):
      let sum = ints[e] + ints[e+1] + ints[e+2]
      if sum > previous:
        counter += 1

      previous = sum

    return counter
