include aoc

type Move = object
  n, start, finish: Natural

day 5:
  let stacks = block:
    var result: array[0..8, seq['A'..'Z']]

    for x in 0..8:
      for y in countdown(7, 0):
        let maybeBox = lines[y][1 + (x * 4)];
        if maybeBox == ' ': break
        result[x].add maybeBox

    result

  let moves = collect:
    for line in lines[10..^1]:
      let (success, n, start, finish) = scanTuple(line, "move $i from $i to $i")
      assert success
      Move(n: n, start: start - 1, finish: finish - 1)

  part 1:
    var stacks1 = stacks
    for move in moves:
      for _ in 0..<move.n:
        stacks1[move.finish].add stacks1[move.start].pop()

    result = ""
    for stack in stacks1:
      result.add stack[^1]

  part 2:
    var stacks2 = stacks
    for move in moves:
      for i in stacks2[move.start][^(move.n)..^1]:
        stacks2[move.finish].add i
      stacks2[move.start].setLen(stacks2[move.start].len - move.n)

    result = ""
    for stack in stacks2:
      result.add stack[^1]