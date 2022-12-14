include aoc
import std/options

type
  PacketKind = enum
    Value, List

  Packet = ref object
    case kind: PacketKind
    of Value:
      value: int
    of List:
      list: seq[Packet]

proc `$`(packet: Packet): string =
  case packet.kind:
  of Value:
    $packet.value
  of List:
    "[" & packet.list.mapIt($it).join(",") & "]"

proc eatChar(input: string, i: var int, c: char) =
  if input[i] == c:
    inc i
  else:
    assert false

proc parseInt(input: string, i: var int): Packet =
  var value: int
  i += parseInt(input, value, i)
  Packet(kind: Value, value: value)

proc parseList(input: string, i: var int): Packet =
  result = Packet(kind: List)

  eatChar(input, i, '[')

  while true:
    case input[i]:
    of ']':
      # Handle empty list where ] comes right after [
      break
    of '[':
      result.list.add parseList(input, i)
    of Digits:
      result.list.add parseInt(input, i)
    else:
      assert false

    case input[i]:
    of ',':
      eatChar(input, i, ',')
    of ']':
      break
    else:
      assert false

  eatChar(input, i, ']')
  if input[i] == '\n':
    inc i

proc parseInput(input: string): seq[(Packet, Packet)] =
  result = newSeqOfCap[(Packet, Packet)](input.len div 3)
  var i = 0
  while true:
    result.add (parseList(input, i), parseList(input, i))
    if i >= input.len: break
    eatChar(input, i, '\n')

proc compare(a, b: Packet): int

proc compare(a, b: seq[Packet]): int =
  for i in 0..min(a.high, b.high):
    let test = compare(a[i], b[i])
    if test != 0:
      return test

  system.cmp(a.len, b.len)

proc compare(a, b: Packet): int =
  if a.kind == Value and b.kind == Value:
    system.cmp(a.value, b.value)
  elif a.kind == List and b.kind == List:
    compare(a.list, b.list)
  else:
    if a.kind == Value:
      compare(@[a], b.list)
    else:
      compare(a.list, @[b])

proc initDivider(value: int): Packet =
  Packet(kind: List, list: @[
    Packet(kind: List, list: @[
      Packet(kind: Value, value: value)
    ])
  ])

let dividers = [initDivider(2), initDivider(6)]

proc funniSorted(input: seq[(Packet, Packet)]): seq[Packet] =
  result = newSeqOfCap[Packet](input.len * 2 + 2)

  for (a, b) in input:
    result.add a
    result.add b
  for a in dividers:
    result.add a

  result.sort(compare)

day 13:
  let parsed = inputRaw.parseInput()

  part 1:
    result = 0
    for i, (a, b) in parsed:
      if compare(a, b) == -1:
        result += i + 1

  part 2:
    result = 1
    for i, packet in parsed.funniSorted():
      if packet in dividers:
        result *= i + 1
