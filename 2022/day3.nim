include aoc

proc toSet(s: string): set['A'..'z'] =
  for c in s:
    result.incl c

iterator chunked*[T](s: openArray[T], size: Positive): seq[T] =
  var i: int
  while i + size < len(s):
    yield s[i ..< i+size]
    i += size
  yield s[i .. ^1]

proc getPriority(c: char): int =
  if c in 'A'..'Z':
    c.ord - 'A'.ord + 27
  else:
    c.ord - 'a'.ord + 1

day 3:
  let sacks = collect:
    for line in lines:
      let halfIndex = line.len div 2
      (line[0..<halfIndex].toSet, line[halfIndex..^1].toSet)

  part 1:
    sacks.mapIt((it[0] * it[1]).toSeq[0].getPriority()).sum()
  part 2:
    sacks.chunked(3).toSeq.mapIt(
      it.mapIt(it[0] + it[1])
    ).mapIt(
      it[0] * it[1] * it[2]
    ).mapIt(
      it.toSeq[0].getPriority()
    ).sum()
