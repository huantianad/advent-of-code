include aoc

type
  DeterministicDie = object of RootObj
    currentValue: range[1..100]
    timesRolled: Natural

  Player = object of RootObj
    position: range[0..9]
    score: Natural

proc `+=`(a: var (int, int), b: (int, int)) =
  a[0] += b[0]
  a[1] += b[1]

proc `*`(a: (int, int), b: int): (int, int) =
  (a[0] * b, a[1] * b)

proc max(input: (int, int)): int =
  if input[0] > input[1]:
    input[0]
  else:
    input[1]

proc toPlayer(input: string): Player =
  let (success, _, startingPos) = input.scanTuple("Player $i starting position: $i")
  if not success:
    raise newException(ValueError, "THIS IS BAD")

  result.position = startingPos - 1

proc doTurn(player: var Player, rollResult: int) =
  player.position = (player.position + rollResult) mod 10
  player.score += player.position + 1

proc roll(die: var DeterministicDie): int =
  for _ in 1..3:
    result += die.currentValue
    die.timesRolled += 1

    if die.currentValue == 100:
      die.currentValue = 1
    else:
      die.currentValue += 1

var cache = initTable[(Player, Player, range[1..2]), (int, int)]()

proc possibleRolls(): CountTable[int] {.compileTime.} =
  for a in 1..3:
    for b in 1..3:
      for c in 1..3:
        result.inc(a + b + c)

proc simulate(player1, player2: Player, currentPlayer: range[1..2]): (int, int) =
  if (player1, player2, currentPlayer) in cache:
    return cache[(player1, player2, currentPlayer)]

  if currentPlayer == 1:
    for roll, times in possibleRolls():
      var newPlayer1 = player1
      newPlayer1.doTurn(roll)

      if newPlayer1.score >= 21:
        result += (times, 0)
      else:
        result += simulate(newPlayer1, player2, 2) * times

  elif currentPlayer == 2:
    for roll, times in possibleRolls():
      var newPlayer2 = player2
      newPlayer2.doTurn(roll)

      if newPlayer2.score >= 21:
        result += (0, times)
      else:
        result += simulate(player1, newPlayer2, 1) * times

  cache[(player1, player2, currentPlayer)] = result

day 21:
  [originalPlayer1, originalPlayer2] <- input.splitLines.map(toPlayer)

  part 1:
    var player1 = originalPlayer1
    var player2 = originalPlayer2

    var die = DeterministicDie(currentValue: 1)

    while true:
      player1.doTurn(die.roll())
      if player1.score >= 1000:
        return die.timesRolled * player2.score

      player2.doTurn(die.roll())
      if player2.score >= 1000:
        return die.timesRolled * player1.score

  part 2:
    simulate(originalPlayer1, originalPlayer2, 1).max
