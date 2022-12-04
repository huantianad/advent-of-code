include aoc

proc check(i: (HSlice[int, int], HSlice[int, int])): bool =
  let (a, b) = i
  a.a >= b.a and a.b <= b.b or a.a <= b.a and a.b >= b.b

proc check2(i: (HSlice[int, int], HSlice[int, int])): bool =
  let (a, b) = i
  for x in a:
    if x in b: return true
  for y in b:
    if y in a: return true

day 4:
  let parsed = collect:
    for line in lines:
      let (success, a, b, x, y) = scanTuple(line, "$i-$i,$i-$i")
      assert success
      (a..b, x..y)

  part 1:
    parsed.filter(check).len
  part 2:
    parsed.filter(check2).len