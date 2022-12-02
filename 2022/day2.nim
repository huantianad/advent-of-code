include aoc

type
  Round = object
    opponent: 'A'..'C'
    player: 'X'..'Z'

# I know this is cursed
proc `+`(a: char, b: int): char = char(ord(a) + b)
proc `-`(a, b: char): int = ord(a) - ord(b)

func calcScore1(round: Round): int {.compileTime.} =
  #  RPS Player
  # R360
  # P036
  # S603
  let opponent = round.opponent - 'A'
  let player = round.player - 'X'

  ((player - opponent + 1 + 3) mod 3) * 3 + (player + 1)

func calcScore2(round: Round): int {.compileTime.}  =
  #  LDW
  # R312
  # P123
  # S231
  let opponent = round.opponent - 'A'
  let player = round.player - 'X'

  ((player + opponent - 1 + 3) mod 3 + 1) + player * 3

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
