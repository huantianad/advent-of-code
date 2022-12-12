include aoc
import bigints

type Monkey = object
  items: seq[int]
  operation: int -> int
  testVal: int
  ifTrue, ifFalse: int

  counter: int

proc parseInput(input: string): seq[Monkey] =
  collect:
    for rawMonkey in input.split("\n\n"):
      let monkeyLines = rawMonkey.splitLines().mapIt(it.strip)
      var monkey = Monkey()

      monkey.items = monkeyLines[1]["Starting items: ".len..^1]
        .split(", ").mapIt(it.parseInt)

      monkey.operation = block:
        let (addSuc, addVal) = monkeyLines[2].scanTuple("Operation: new = old + $i")
        let (multSuc, multVal) = monkeyLines[2].scanTuple("Operation: new = old * $i")
        let squareSuc = monkeyLines[2].scanf("Operation: new = old * old")

        if addSuc:
          capture addVal:
            (x: int) => x + addVal
        elif multSuc:
          capture multVal:
            (x: int) => x * multVal
        elif squareSuc:
          (x: int) => x * x
        else:
          assert false; (x: int) => x

      monkey.testVal = monkeyLines[3].scanTuple("Test: divisible by $i")[1]
      monkey.ifTrue = monkeyLines[4].scanTuple("If true: throw to monkey $i")[1]
      monkey.ifFalse = monkeyLines[5].scanTuple("If false: throw to monkey $i")[1]

      monkey

proc run(monkeys: seq[Monkey], times: Natural, part: 1..2): seq[Monkey] =
  result = monkeys

  let lcm = monkeys.mapIt(it.testVal).lcm()

  for _ in 1..times:
    for monkey in result.mitems:
      for item in monkey.items:
        var worry = monkey.operation(item)
        if part == 1: worry = worry div 3

        let target =
          if worry mod monkey.testVal == 0:
            monkey.ifTrue
          else:
            monkey.ifFalse

        result[target].items.add(worry mod lcm)

        inc monkey.counter

      monkey.items.setLen(0)

proc business(monkeys: seq[Monkey]): int =
  let sorted = monkeys.mapIt(it.counter).sorted()
  sorted[^1] * sorted[^2]

day 11:
  let monkeys = input.parseInput()

  part 1:
    monkeys.run(20, 1).business()
  part 2:
    monkeys.run(10000, 2).business()