include aoc
import std/json

{.experimental: "strictFuncs".}

type
  SnailKind = enum
    snPair, snLiteral

  SnailNumber = ref object of RootObj
    parent: SnailNumber

    case kind: SnailKind
    of snPair: left, right: SnailNumber
    of snLiteral: value: int

func `$`(input: SnailNumber): string =
  if input == nil: return "nil"
  case input.kind:
  of snLiteral:
    return fmt"{input.value}"
  of snPair:
    return fmt"[{input.left}, {input.right}]"

proc toSnailNumber(input: JsonNode, parent: SnailNumber = nil): SnailNumber =
  if input.kind == JInt:
    result = SnailNumber(kind: snLiteral, value: input.getInt, parent: parent)
  else:
    result = SnailNumber(kind: snPair, parent: parent)
    result.left = input[0].toSnailNumber(result)
    result.right = input[1].toSnailNumber(result)

proc toSnailNumber(input: string): SnailNumber =
  input.parseJson.toSnailNumber

proc explode(input: SnailNumber): bool =
  var lastLeft: SnailNumber = nil
  var explodedRightValue = -1
  var doneExploding = false

  proc traverse(num: SnailNumber, depth = 0) =
    if doneExploding: return

    if depth == 4 and num.kind == snPair and explodedRightValue == -1:
      if lastLeft != nil: lastLeft.value += num.left.value
      explodedRightValue = num.right.value
      if num.parent.left == num:
        num.parent.left = SnailNumber(kind: snLiteral, value: 0, parent: num.parent)
      else:
        num.parent.right = SnailNumber(kind: snLiteral, value: 0, parent: num.parent)
      return

    if explodedRightValue == -1:
      if num.kind == snLiteral:
        lastLeft = num
    else:
      if num.kind == snLiteral:
        num.value += explodedRightValue
        doneExploding = true
    if num.kind == snPair:
      traverse(num.left, depth + 1)
      traverse(num.right, depth + 1)

  traverse(input)
  return explodedRightValue != -1

proc split(input: SnailNumber): bool =
  var finished = false
  proc traverse(num: SnailNumber) =
    if finished: return
    if num.kind == snLiteral and num.value >= 10:
      finished = true

      var newSnail = SnailNumber(kind: snPair, parent: num.parent)
      newSnail.left = SnailNumber(kind: snLiteral, value: num.value div 2, parent: newSnail)
      newSnail.right = SnailNumber(kind: snLiteral, value: num.value - num.value div 2, parent: newSnail)

      if num.parent.left == num:
        num.parent.left = newSnail
      else:
        num.parent.right = newSnail

    elif num.kind == snPair:
      traverse(num.left)
      traverse(num.right)

  traverse(input)
  return finished

proc reduce(input: SnailNumber) =
  while true:
    if input.explode: continue
    if not input.split: break

proc addSnail(left, right: SnailNumber, parent: SnailNumber = nil): SnailNumber =
  result = SnailNumber(kind: snPair, parent: parent, left: left, right: right)
  result.left.parent = result
  result.right.parent = result
  result.reduce

proc mag(input: SnailNumber): int =
  if input.kind == snLiteral:
    return input.value
  return input.left.mag * 3 + input.right.mag * 2

day 18:
  let parsed = lines.map(toSnailNumber)
  let parseda = lines.map(toSnailNumber)

  part 1:
    parsed.foldl(a.addSnail(b)).mag
  part 2:
    let mags = collect:
      for i, a in parseda:
        for j, b in parseda:
          if i != j:
            var copA, copB: SnailNumber
            deepCopy(copA, a)
            deepCopy(copB, b)
            copB.addSnail(copA).mag
    mags.max
