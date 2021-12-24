include aoc
import re

type
  ChunkKind = enum
    Increaser, Decreaser

  Chunk = tuple
    kind: ChunkKind
    value: int

proc parseChunk(raw: string): Chunk =
  if raw.strip =~ re"mul x 0\nadd x z\nmod x 26\ndiv z (1|26)\nadd x (-?\d+)\neql x w\neql x 0\nmul y 0\nadd y 25\nmul y x\nadd y 1\nmul z y\nmul y 0\nadd y w\nadd y (\d+)\nmul y x\nadd z y":
    if matches[0].parseInt == 26:
      return (Decreaser, matches[1].parseInt)
    else:
      return (Increaser, matches[2].parseInt)
  else:
    assert false

proc getMax(num: int): (int, int) =
  for offset in 1..9:
    if offset + num > 9: return
    result = (offset, offset + num)

proc getMin(num: int): (int, int) =
  for offset in countdown(9, 1):
    if offset + num < 1: return
    result = (offset, offset + num)

day 24:
  # Index to remove empty string at start
  let chunks = input.split("inp w")[1..^1].map(parseChunk)
  echo chunks.join("\n")

  var resultMax = ""
  var resultMin = ""
  var increasersIndex: seq[int]

  for chunkNum, chunk in chunks:
    case chunk.kind
    of Increaser:
      resultMax &= "0"
      resultMin &= "0"
      increasersIndex.add(chunkNum)
    of Decreaser:
      let matchingIIndex = increasersIndex.pop()
      let matchingIncreaser = chunks[matchingIIndex]

      let (maxInc, maxDec) = getMax(matchingIncreaser.value + chunk.value)
      resultMax &= $maxDec
      resultMax[matchingIIndex] = ($maxInc)[0]

      let (minInc, minDec) = getMin(matchingIncreaser.value + chunk.value)
      resultMin &= $minDec
      resultMin[matchingIIndex] = ($minInc)[0]

  part 1:
    resultMax
  part 2:
    resultMin
