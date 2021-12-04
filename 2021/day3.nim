include aoc

proc switchZeroAndOne(input: int): int =
  if input == 1: 0 else: 1

proc switchZeroAndOne(input: char): char =
  if input == '1': '0' else: '1'

proc switchZeroAndOne(input: string): string =
  collect(
    for bit in input:
      bit.switchZeroAndOne
  ).join

proc switchZeroAndOne[T: int | char | string](input: openArray[T]): seq[T] =
  input.map(switchZeroAndOne)

proc mostFrequent(input: seq[int], invert = false): int =
  let numZero = input.count(0)
  let numOne = input.count(1)

  if numOne >= numZero xor invert: 1 else: 0


day 3:
  proc solvePart2(cols: seq[seq[int]], invert: bool): int =
    var output: string

    for colNum, col in cols.pairs:
      let remainingBits = collect:
        for line in lines:
          if line.startsWith(output): parseInt($line[colNum])

      if remainingBits.len == 1: break

      output &= $mostFrequent(remainingBits, invert)

    for line in lines:
      if line.startsWith(output):
        return parseBinInt(line)

  let cols = collect:
    for colNum in 0..<lines[0].len: collect:
      for line in lines: parseInt($line[colNum])

  part 1, int:
    let gammaArray = cols.mapIt(mostFrequent(it)).join

    let gamma = parseBinInt(gammaArray)
    let epsilon = parseBinInt(gammaArray.switchZeroAndOne)

    gamma * epsilon

  part 2:
    solvePart2(cols, invert = false) * solvePart2(cols, invert = true)