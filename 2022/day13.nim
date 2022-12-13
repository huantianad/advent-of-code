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

proc parseLine(input: string, i: var int): Packet =
  result = Packet(kind: List)

  eatChar(input, i, '[')

  while true:
    if input[i] == '[':
      result.list.add parseLine(input, i)
    else:
      var number: int
      let incBy = parseInt(input, number, i)
      if incBy > 0:
        i += incBy
        result.list.add Packet(kind: Value, value: number)

    if input[i] == ',':
      eatChar(input, i, ',')
      continue
    elif input[i] == ']':
      eatChar(input, i, ']')
      break
    else:
      assert false

  if input[i] == '\n':
    inc i

proc parseInput(input: string): seq[(Packet, Packet)] =
  var i = 0
  while true:
    result.add (parseLine(input, i), parseLine(input, i))
    if i >= input.len: break
    eatChar(input, i, '\n')

proc compare(a, b: Packet): Option[bool]

proc compare(a, b: int): Option[bool] =
  if a < b:
    true.some
  elif a > b:
    false.some
  else:
    bool.none

proc compare(a, b: seq[Packet]): Option[bool] =
  for i in 0..min(a.high, b.high):
    let test = compare(a[i], b[i])
    if test.isSome:
      return test

  compare(a.len, b.len)

proc compare(a, b: Packet): Option[bool] =
  if a.kind == Value and b.kind == Value:
    compare(a.value, b.value)
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

  result.sort((a, b) => not compare(a, b).get())

day 13:
  let parsed = inputRaw.parseInput()

  part 1:
    result = 0
    for i, (a, b) in parsed:
      if compare(a, b).get():
        result += i + 1

  part 2:
    result = 1
    for i, packet in parsed.funniSorted():
      if packet in dividers:
        result *= i + 1
