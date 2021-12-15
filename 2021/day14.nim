include aoc

proc realCount(pairsCount: CountTable[string], original: string): int =
  var counter = initCountTable[char]()
  for pair, occurences in pairsCount:
    counter.inc(pair[0], occurences * 2)
    counter.inc(pair[1], -occurences)

  counter.inc(original[0], -1)
  counter.inc(original[^1], 2)

  counter.largest.val - counter.smallest.val

day 14:
  # Input parsing
  let polymer = lines[0]

  let rules = collect:
    for line in lines:
      let (success, match, replace) = line.scanTuple("$+ -> $+")
      if success: {match: replace}

  # Actual solution
  let pairs = zip(polymer, polymer[1..^1]).mapIt(it[0] & it[1]).toCountTable
  var newPairs = @[pairs]

  for i in 1..40:
    var thisNewPair = initCountTable[string]()
    for match, replace in rules:
      let occurences = newPairs[^1].getOrDefault(match)
      thisNewPair.inc(match[0] & replace, occurences)
      thisNewPair.inc(replace & match[1], occurences)

    newPairs.add(thisNewPair)

  part 1:
    realCount(newPairs[10], polymer)
  part 2:
    realCount(newPairs[40], polymer)
