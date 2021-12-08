include aoc

day 7:
  let parsed = input.split(",").map(parseInt)

  proc solve(expression: int -> int): int =
    collect(
      for pos in parsed.min..parsed.max:
        parsed.mapIt((it - pos).abs.expression).sum
    ).min

  part 1:
    solve(diff => diff)
  part 2:
    solve(diff => diff * (diff + 1) div 2)