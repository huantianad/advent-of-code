include aoc

proc contains(a, b: HSlice[int, int]): bool =
  a.a >= b.a and a.b <= b.b

proc `∩`(a, b: HSlice[int, int]): bool =
  a.b >= b.a and a.a <= b.b

day 4:
  let parsed = collect:
    for line in lines:
      let (success, a, b, x, y) = scanTuple(line, "$i-$i,$i-$i")
      assert success
      (a..b, x..y)

  part 1:
    parsed.filterIt((let (a, b) = it; a in b or b in a)).len
  part 2:
    parsed.filterIt(it[0] ∩ it[1]).len
