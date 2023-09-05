import std/[
  algorithm,
  math,
  sequtils,
  strutils,
]

import aocd

2022.day 1:
  let totals = input
    .strip()
    .split("\n\n")
    .mapIt(it.splitLines().map(parseInt).sum())
    .sorted(SortOrder.Descending)

  part 1:
    totals[0]

  part 2:
    totals[0..2].sum
