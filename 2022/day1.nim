include aoc

day 1:
  let inted = lines.mapIt(if it == "": -1 else: parseInt(it))

  var totals: seq[int]
  var total: int

  for num in inted:
    if num == -1:
      totals.add total
      total = 0
    else:
      total += num

  totals.sort(SortOrder.Descending)

  part 1:
    totals[0]

  part 2:
    totals[0..2].sum
