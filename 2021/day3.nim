include aoc


proc mostFrequent(input: seq[int]): int =
  let numZero = input.count(0)
  let numOne = input.count(1)

  if numOne >= numZero: 1
  else: 0

proc switchZeroAndOne(input: int): int =
  if input == 1: 0 else: 1

proc switchZeroAndOne(input: openArray[int]): seq[int] =
  collect:
    for element in input:
      switchZeroAndOne(element)


day 3:
  proc solvePart2(input: seq[seq[int]], invert: bool): int =
    var ignored = initOrderedSet[int]()

    for colNum, col in input.pairs:
      let remainingBits = collect:
        for rowNum, bit in col.pairs:
          if not ignored.contains(rowNum): bit

      if remainingBits.len == 1: break

      var most = mostFrequent(remainingBits)
      if invert: most = most.switchZeroAndOne

      for rowNum, bit in col.pairs:
        if bit != most:
          ignored.incl rowNum

    for rowNum, val in lines.pairs:
      if not ignored.contains rowNum:
        return fromBin[int](val)

  let cols = collect:
    for colNum in 0..<lines[0].len: collect:
      for line in lines: parseInt($line[colNum])

  part 1, int:
    let gammaArray = cols.map(mostFrequent)

    let gamma = fromBin[int](gammaArray.join)
    let epsilon = fromBin[int](gammaArray.switchZeroAndOne.join)

    gamma * epsilon
  part 2:
    solvePart2(cols, invert = false) * solvePart2(cols, invert = true)