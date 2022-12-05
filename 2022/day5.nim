include aoc

type Move = object
  n, start, finish: Natural

day 5:
  var stacks: array[0..8, seq['A'..'Z']]
  for x in 0..8:
    for y in countdown(7, 0):
      if lines[y][1 + (x * 4)] == ' ':
        break
      stacks[x].add lines[y][1 + (x * 4)]

  let moves = collect:
    for line in lines[10..^1]:
      let (success, n, start, finish) = scanTuple(line, "move $i from $i to $i")
      assert success
      Move(n: n, start: start - 1, finish: finish - 1)

  # for move in moves:
  #   for _ in 0..<move.n:
  #     stacks[move.finish].add stacks[move.start].pop()

  for move in moves:
    for i in stacks[move.start][^(move.n)..^1]:
      stacks[move.finish].add i
    stacks[move.start].setLen(stacks[move.start].len - move.n)

  part 1:
    var res = ""
    for stack in stacks:
      res.add stack[^1]
    res
  part 2:
    "Part 2 solution"