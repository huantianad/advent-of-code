include aoc

type
  Instruction = tuple
    state: bool
    xMin, xMax, yMin, yMax, zMin, zMax: int

  Point = tuple
    x, y, z: int


proc `$`(self: Instruction): string =
  fmt"({self.state}, x: {self.xMin}..{self.xMax}, y: {self.yMin}..{self.yMax}, z: {self.zMin}..{self.zMax})"

proc size(inst: Instruction): int =
  (if inst.state: 1 else: -1) *
  (inst.xMax - inst.xMin + 1) * (inst.yMax - inst.yMin + 1) * (inst.zMax - inst.zMin + 1)

proc betterAdd(self: var seq[Instruction], it: Instruction) =
  var opposite = it
  opposite.state = not it.state
  if opposite in self:
    self.del(self.find(opposite))
  else:
    self.add(it)

proc splitDel(reactor: seq[Instruction], newInst: Instruction): seq[Instruction] =
  result = reactor

  for inst in reactor:
    let overlap = (
      state: false,
      xMin: max(inst.xMin, newInst.xMin), xMax: min(inst.xMax, newInst.xMax),
      yMin: max(inst.yMin, newInst.yMin), yMax: min(inst.yMax, newInst.yMax),
      zMin: max(inst.zMin, newInst.zMin), zMax: min(inst.zMax, newInst.zMax),
    )

    if overlap.xMax < overlap.xMin or overlap.yMax < overlap.yMin or overlap.zMax < overlap.zMin:
      continue

    if inst.state:
      result.betterAdd(overlap)
    else:
      var temp = overlap
      temp.state = true
      result.betterAdd(temp)


day 22:
  let parsed: seq[Instruction] = collect:
    for line in lines:
      let (_, state, xMin, xMax, yMin, yMax, zMin, zMax) = line.scanTuple("$w x=$i..$i,y=$i..$i,z=$i..$i")
      (state == "on", xMin, xMax, yMin, yMax, zMin, zMax)

  part 1:
    var reactor = initHashSet[Point]()

    for state, xMin, xMax, yMin, yMax, zMin, zMax in parsed.items:
      for x in max(-50, xMin)..min(50, xMax):
        for y in max(-50, yMin)..min(50, yMax):
          for z in max(-50, zMin)..min(50, zMax):
            if state:
              reactor.incl((x, y, z))
            else:
              reactor.excl((x, y, z))

    reactor.len

  part 2:
    var reactor: seq[Instruction]

    for inst in parsed:
      reactor = reactor.splitDel(inst)
      if inst.state:
        reactor.betterAdd(inst)

    reactor.map(size).sum
