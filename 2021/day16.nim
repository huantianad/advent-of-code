include aoc

type
  PacketKind = enum
    pkOperator,
    pkValue

  Packet = object of RootObj
    version: int
    typeId: int

    case kind: PacketKind
    of pkOperator: subpackets: seq[Packet]
    of pkValue: value: int


proc `$`(input: Packet): string =
  case input.kind:
  of pkOperator:
    let subpackets = input.subpackets.mapIt($it).join(", ")
    fmt"Packet(v: {input.version}, t: {input.typeId}, subpackets: [{subpackets}])"
  of pkValue:
    fmt"Packet(v: {input.version}, t: {input.typeId}, value: {input.value})"

proc toPacket(raw: string): (Packet, string)

proc toOperatorPacket(raw: string): (Packet, string) =
  var finalRemaining: string
  var subpackets: seq[Packet]

  if raw[6] == '0':
    let length = raw[7..21].parseBinInt
    var remaining = raw[22..21 + length]

    while not remaining.isEmptyOrWhitespace:
      let (subpacket, newRemaining) = remaining.toPacket()
      remaining = newRemaining
      subpackets.add(subpacket)

    finalRemaining = raw[22 + length..^1]
  else:
    let length = raw[7..17].parseBinInt
    var remaining = raw[18..^1]

    for i in 0..<length:
      let (subpacket, newRemaining) = remaining.toPacket()
      remaining = newRemaining
      subpackets.add(subpacket)

    finalRemaining = remaining

  (Packet(
    kind: pkOperator,
    version: raw[0..2].parseBinInt,
    typeId: raw[3..5].parseBinInt,
    subpackets: subpackets
  ), finalRemaining)

proc toValuePacket(raw: string): (Packet, string) =
  var remaining = raw[6..^1]
  var binaryValue = ""
  var i = 0

  while true:
    let isDone = remaining[0] == '0'
    binaryValue &= remaining[1..4]
    remaining = remaining[5..^1]

    if isDone: break
    i += 1

  (Packet(
    kind: pkValue,
    version: raw[0..2].parseBinInt,
    typeId: raw[3..5].parseBinInt,
    value: binaryValue.parseBinInt
  ), remaining)

proc toPacket(raw: string): (Packet, string) =
  let typeId = raw[3..5].parseBinInt

  if typeId == 4:
    toValuePacket(raw)
  else:
    toOperatorPacket(raw)


proc sumVersions(input: Packet): int =
  result += input.version

  if input.kind == pkOperator:
    for child in input.subpackets:
      result += sumVersions(child)

proc getValue(input: Packet): int =
  if input.kind == pkValue:
    input.value
  else:
    case input.typeId:
      of 0: input.subpackets.map(getValue).sum
      of 1: input.subpackets.map(getValue).prod
      of 2: input.subpackets.map(getValue).min
      of 3: input.subpackets.map(getValue).max
      of 5: int(input.subpackets[0].getValue > input.subpackets[1].getValue)
      of 6: int(input.subpackets[0].getValue < input.subpackets[1].getValue)
      of 7: int(input.subpackets[0].getValue == input.subpackets[1].getValue)
      else: raise newException(ValueError, fmt"{input.typeId} is not a valid operator type ID.")

proc hexToBin(input: string): string =
  for digit in input:
    result &= ($digit).parseHexInt.toBin(4)


day 16:
  let rawInput = input.hexToBin
  let (packet, _) = rawInput.toPacket

  part 1:
    packet.sumVersions
  part 2:
    packet.getValue
