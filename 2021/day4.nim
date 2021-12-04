include aoc

let testInput = """7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"""

type
  Board = tuple
    values: seq[seq[int]]

proc newBoard(rawInput: string): Board =
  let values = collect:
    for row in rawInput.split("\n"): collect:
      for value in row.split:
        if not value.isEmptyOrWhitespace:
          parseInt(value)

  return (values: values)

proc hasWon(board: Board, passedTurns: seq[int]): bool =
  for row in board.values:
    if row.allit(it in passedTurns):
      return true

  for colNum in 0..4:
    let col = collect:
      for row in board.values: row[colNum]

    if col.allit(it in passedTurns): return true

day 4:
  [rawTurns, *rawBoards] <- input.split("\n\n")

  let turns = rawTurns.split(",").map(parseInt)
  let boards = collect:
    for rawBoard in rawBoards:
      newBoard(rawBoard)

  var winner: Board
  var hasWon: bool
  var mostRecentIndex: int

  # for turnIndex in 0..<turns.len:
  #   for board in boards:
  #     if board.hasWon(turns[0..turnIndex]):
  #       winner = board
  #       hasWon = true
  #       mostRecentIndex = turnIndex
  #       break

  #   if hasWon: break

  # let winningValues = collect:
  #   for row in winner.values:
  #     for value in row: value

  # let unmarked = winningValues.filterIt(it notin turns[0..mostRecentIndex])
  # let winningValue = turns[mostRecentIndex]

  var hasNotWonBoardIndexes = (0..<boards.len).toSeq.toHashSet

  for turnIndex in 0..<turns.len:
    for boardIndex, board in boards.pairs:
      if board.hasWon(turns[0..turnIndex]):
        hasNotWonBoardIndexes.excl(boardIndex)
        if board == winner:
          mostRecentIndex = turnIndex
          hasWon= true
          break

      if hasNotWonBoardIndexes.len == 1: winner = boards[hasNotWonBoardIndexes.pop]
      if hasWon: break

    if hasNotWonBoardIndexes.len == 1: winner = boards[hasNotWonBoardIndexes.pop]
    if hasWon: break


  let winningValues = collect:
    for row in winner.values:
      for value in row: value

  let unmarked = winningValues.filterIt(it notin turns[0..mostRecentIndex])
  let winningValue = turns[mostRecentIndex]

  part 1:
    winningValue * sum(unmarked)
  part 2:
    winningValue * sum(unmarked)