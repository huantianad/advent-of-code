include aoc
import std/options

type
  MonkeyKind = enum
    Value, Add, Sub, Mul, Div
  Monkey = object
    value: int
    case kind: MonkeyKind
    of Value: discard
    else: a, b: string

proc parseInput(lines: seq[string]): Table[string, Monkey] =
  collect(
    for line in lines:
      let (suc, name, value) = line.scanTuple("$+: $i")
      if suc:
        (name, Monkey(kind: Value, value: value))
      else:
        let (suc, name, a, op, b) = line.scanTuple("$+: $+ $c $+")
        assert suc
        let kind: Add..Div = case op:
          of '+': Add
          of '-': Sub
          of '*': Mul
          of '/': Div
          else: assert false; Add
        (name, Monkey(kind: kind, a: a, b: b))
    ).toTable()

const reverseOp = [
  Add: Sub,
  Sub: Add,
  Mul: Div,
  Div: Mul
]

proc op(op: Add..Div, a, b: int): int =
  case op:
    of Add: a + b
    of Sub: a - b
    of Mul: a * b
    of Div: a div b

proc eval(table: var Table[string, Monkey], name: string): int =
  let this = table[name]
  if this.kind == Value:
    return this.value

  table[name].value = op(this.kind, table.eval(this.a), table.eval(this.b))
  table[name].value

proc findPathToHumn(table: Table[string, Monkey], name: string): HashSet[string] =
  if name == "humn":
    return ["humn"].toHashSet

  let this = table[name]
  if this.kind == Value:
    return

  result = table.findPathToHumn(this.a) + table.findPathToHumn(this.b)
  if result.len > 0:
    result.incl name

proc eval2(
    table: var Table[string, Monkey],
    name: string,
    target: int,
    pathToHumn: HashSet[string]
  ): int =
  if name == "humn": return target

  let this = table[name]
  assert this.kind != Value

  if name == "root":
    if this.a in pathToHumn:
      return table.eval2(this.a, table.eval(this.b), pathToHumn)

    elif this.b in pathToHumn:
      return table.eval2(this.b, table.eval(this.a), pathToHumn)

  if this.a in pathToHumn:
    let newTarget = op(reverseOp[this.kind], target, table.eval(this.b))
    return table.eval2(this.a, newTarget, pathToHumn)

  elif this.b in pathToHumn:
    let a = table.eval(this.a)
    let newTarget = case this.kind:
    of Add: target - a
    of Sub: a - target
    of Mul: target div a
    of Div: a div target
    else: assert false; 1
    return table.eval2(this.b, newTarget, pathToHumn)

day 21:
  var parsed = lines.parseInput()
  let pathToHumn = parsed.findPathToHumn("root")

  part 1:
    parsed.eval("root")

  part 2:
    parsed.eval2("root", 0, pathToHumn)