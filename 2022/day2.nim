include aoc

type
  Round = object
    opponent: 'A'..'C'
    player: 'X'..'Z'

proc index[T: range](r: T): int = r.ord - T.low.ord

func calcScore1(round: Round): int {.compileTime.} =
  #  RPS Player
  # R360
  # P036
  # S603
  let opponent = round.opponent.index
  let player = round.player.index

  ((player - opponent + 1 + 3) mod 3) * 3 + (player + 1)

func calcScore2(round: Round): int {.compileTime.}  =
  #  LDW
  # R312
  # P123
  # S231
  let opponent = round.opponent.index
  let player = round.player.index

  ((player + opponent - 1 + 3) mod 3 + 1) + (player * 3)

func makeScoresArray(calc: Round -> int): array['A'..'C', array['X'..'Z', int]] {.compileTime.} =
  for opponent in 'A'..'C':
    for player in 'X'..'Z':
      result[opponent][player] = calc(Round(opponent: opponent, player: player))

const scores1 = makeScoresArray(calcScore1)
const scores2 = makeScoresArray(calcScore2)

day 2:
  let parsed = collect:
    for line in lines:
      Round(opponent: line[0], player: line[2])

  part 1:
    parsed.mapIt(scores1[it.opponent][it.player]).sum()
  part 2:
    parsed.mapIt(scores2[it.opponent][it.player]).sum()
