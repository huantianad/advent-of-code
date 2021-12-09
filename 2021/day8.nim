include aoc

type
  RawRow = tuple
    unique: seq[HashSet[char]]
    output: seq[HashSet[char]]

proc getOnlyElement[T](hashSet: HashSet[T]): T =
  for x in hashSet:
    return x

proc getOnlyLength(row: RawRow, len: int): HashSet[char] =
  row.unique.filterIt(it.len == len)[0]

proc getAllLength(row: RawRow, len: int): seq[HashSet[char]] =
  row.unique.filterIt(it.len == len)

proc parseRawRow(line: string): RawRow =
  [uniqueRaw, outputRaw] <- line.split(" | ")

  let unique = collect:
    for digit in uniqueRaw.split:
      digit.toSeq.toHashSet
  let output = collect:
    for digit in outputRaw.split:
      digit.toSeq.toHashSet

  (unique, output)

proc parseRow(row: RawRow): int =
  var fakeToReal = initTable[char, char]()

  let one = row.getOnlyLength(2)
  let four = row.getOnlyLength(4)
  let seven = row.getOnlyLength(3)
  let eight = row.getOnlyLength(7)

  fakeToReal['a'] = (seven - one).getOnlyElement

  let zeroSixNine = row.getAllLength(6)
  let twoThreeFive = row.getAllLength(5)

  let oneMissing = zeroSixNine.mapIt(eight - it).map(getOnlyElement).toHashSet

  fakeToReal['f'] = (one - oneMissing).getOnlyElement
  fakeToReal['c'] = (one - [fakeToReal['f']].toHashSet).getOnlyElement

  let six = zeroSixNine.filterIt(fakeToReal['c'] notin it)[0]

  let zeroNine = zeroSixNine.filterIt(it != six)
  let zero = zeroNine.filterIt((it - four).len == 3)[0]
  let nine = zeroNine.filterIt((it - four).len == 2)[0]

  let two = twoThreeFive.filterIt((it - nine).len == 1)[0]
  let threeFive = twoThreeFive.filterIt(it != two)

  let five = threeFive.filterIt(fakeToReal['c'] notin it)[0]
  let three = threeFive.filterIt(fakeToReal['c'] in it)[0]

  let convert = {one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, zero: 0}.toTable

  row.output.mapIt(convert[it]).join.parseInt

proc countSpecial(input: int): int =
  [1, 4, 7, 8].mapIt(($input).count($it)).sum


day 8:
  let outputs = lines.map(parseRawRow).map(parseRow)

  part 1:
    outputs.map(countSpecial).sum
  part 2:
    outputs.sum
