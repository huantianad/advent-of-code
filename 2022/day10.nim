include aoc

type
  OpKind = enum
    opAddx, opNoop
  Instruction = object
    case kind: OpKind
    of opAddx: incBy: int
    of opNoop: discard

proc parseInput(lines: openArray[string]): seq[Instruction] =
  result = newSeqOfCap[Instruction](lines.len)
  for line in lines:
    var intVal: int
    if line.scanf("noop"):
      result.add Instruction(kind: opNoop)
    elif line.scanf("addx $i", intVal):
      result.add Instruction(kind: opAddx, incBy: intVal)
    else:
      assert false

day 10:
  let instructions = lines.parseInput

  var regVals = newSeqOfCap[int](220)
  var x = 1
  for instruction in instructions:
    case instruction.kind:
      of opNoop:
        regVals.add x
      of opAddx:
        regVals.add x
        regVals.add x
        x += instruction.incBy

  part 1:
    result = 0
    for i in [20, 60, 100, 140, 180, 220]:
      result += i * regVals[i - 1]

  part 2:
    result = newStringOfCap(41 * 6)
    result.add '\n'
    for y in 0..<6:
      for x in 0..<40:
        result.add(
          if x - regVals[y * 40 + x] in -1..1:
            '#'
          else:
            ' '
        )

      result.add '\n'
