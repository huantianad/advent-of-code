include aoc

type Board = seq[seq[int]]

proc initBoard(rawInput: string): Board =
  collect:
    for row in rawInput.split("\n"): collect:
      for value in row.split:
        if not value.isEmptyOrWhitespace:
          parseInt(value)

proc hasWon(board: Board, passedTurns: seq[int]): bool =
  for row in board:
    if row.allit(it in passedTurns): return true

  for colNum in 0..4:
    let col = collect:
      for row in board: row[colNum]

    if col.allit(it in passedTurns): return true

proc getScore(board: Board, passedTurns: seq[int]): int =
  let unmarkedValues = collect:
    for row in board:
      for value in row:
        if value notin passedTurns: value

  unmarkedValues.sum * passedTurns[^1]

day 4:
  [rawTurns, *rawBoards] <- input.split("\n\n")

  let turns = rawTurns.split(",").map(parseInt)
  let boards = rawBoards.map(initBoard)

  var winners = initOrderedTable[Board, int]()

  for turnIndex in 0..<turns.len:
    let passedTurns = turns[0..turnIndex]

    for board in boards:
      if board.hasWon(passedTurns) and board notin winners:
        winners[board] = board.getScore(passedTurns)

    if winners.len == boards.len: break

  var firstScore: int
  var lastScore: int
  for score in winners.values:
    firstScore = score
    break
  for score in winners.values:
    lastScore = score

  part 1:
    firstScore
  part 2:
    lastScore
