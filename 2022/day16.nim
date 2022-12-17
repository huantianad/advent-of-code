include aoc
import memo

type
  ValveRaw = object
    name: string
    flowRate: int
    tunnels: seq[string]

  Valve = object
    name: string
    flowRate: int
    tunnels: seq[int]

template findIf[T](s: seq[T], pred: untyped): int =
  var result = -1
  for i, x in s:
    let it {.inject.} = x
    if pred:
      result = i
      break

  result

proc parseInput(lines: seq[string]): seq[ValveRaw] =
  result = newSeqOfCap[ValveRaw](lines.len)
  for line in lines:
    let (suc, name, flowRate, _, _, _, tunnels) = line.scanTuple("Valve $w has flow rate=$i; $w $w to $w $+")
    assert suc
    result.add ValveRaw(name: name, flowRate: flowRate, tunnels: tunnels.split(", "))

proc splitInput(parsed: seq[ValveRaw]): (seq[ValveRaw], seq[ValveRaw]) =
  for valve in parsed:
    if valve.flowRate == 0:
      result[0].add valve
    else:
      result[1].add valve

day 16:
  let (brokenValves, workingValves) = lines.parseInput().splitInput()
  let allValves = workingValves & brokenValves

  var times = newSeqWith[int](allValves.len ^ 2, 10000)
  func `&`(x, y: int): int = x * allValves.len + y

  for valve in allValves:
    let thisIndex = allValves.find(valve)
    for neighbor in valve.tunnels:
      let neighborIndex = allValves.findIf(it.name == neighbor)
      times[thisIndex & neighborIndex] = 1

  for k in 0..allValves.high:
    for i in 0..allValves.high:
      for j in 0..allValves.high:
        times[i & j] = min(times[i & j], times[i & k] + times[k & j])

  let allWorkingValveIndexes = {0'u8..workingValves.high.uint8}
  let aa = allValves.findIf(it.name == "AA")

  proc search(current: int, timeRemaining: int, remainingValves: set[uint8], enableElephant: bool): int {.memoized.} =
    for valveU in remainingValves:
      let valve = valveU.int
      let timeToMove = times[current & valve]
      if timeToMove < timeRemaining:
        let newTime = timeRemaining - 1 - timeToMove
        let nextIter = search(valve, newTime, remainingValves - {valveU}, enableElephant)
        result = max(result, allValves[valve].flowRate * newTime + nextIter)

      if enableElephant:
        result = max(result, search(aa, 26, remainingValves, false))

  part 1:
    search(aa, 30, allWorkingValveIndexes, false)
  part 2:
    search(aa, 26, allWorkingValveIndexes, true)