include aoc

type
  DeterministicDie = object of RootObj
    currentValue: range[1..100]
    timesRolled: Natural

  Player = object of RootObj
    num: range[1..2]
    position: range[0..9]
    score: Natural

proc `+=` (a: var (int, int), b: (int, int)) =
  a[0] += b[0]
  a[1] += b[1]

proc toPlayer(input: string): Player =
  let (success, playerNum, startingPos) = input.scanTuple("Player $i starting position: $i")
  if not success:
    raise newException(ValueError, "THIS IS BAD")

  result.num = playerNum
  result.position = startingPos - 1

proc roll(die: var DeterministicDie): int =
  for _ in 1..3:
    result += die.currentValue
    die.timesRolled += 1

    if die.currentValue == 100:
      die.currentValue = 1
    else:
      die.currentValue += 1

var cache = initTable[(Player, Player, range[1..2]), (int, int)]()

proc simulate(player1, player2: Player, currentPlayer: range[1..2]): (int, int) =
  if (player1, player2, currentPlayer) in cache:
    return cache[(player1, player2, currentPlayer)]

  if currentPlayer == 1:
    for a in 1..3:
      for b in 1..3:
        for c in 1..3:
          let roll = a + b + c
          var newPlayer1 = player1
          newPlayer1.position = (newPlayer1.position + roll) mod 10
          newPlayer1.score += newPlayer1.position + 1

          if newPlayer1.score >= 21:
            result += (1, 0)
          else:
            result += simulate(newPlayer1, player2, 2)

  elif currentPlayer == 2:
    for a in 1..3:
      for b in 1..3:
        for c in 1..3:
          let roll = a + b + c
          var newPlayer2 = player2
          newPlayer2.position = (newPlayer2.position + roll) mod 10
          newPlayer2.score += newPlayer2.position + 1

          if newPlayer2.score >= 21:
            result += (0, 1)
          else:
            result += simulate(player1, newPlayer2, 1)

  cache[(player1, player2, currentPlayer)] = result

day 21:
  [rawPlayer1, rawPlayer2] <- input.splitLines
  let originalPlayer1 = rawPlayer1.toPlayer
  let originalPlayer2 = rawPlayer2.toPlayer

  part 1:
    var player1 = originalPlayer1
    var player2 = originalPlayer2

    var die = DeterministicDie(currentValue: 1)

    while true:
      player1.position = (player1.position + die.roll()) mod 10
      player1.score += player1.position + 1

      if player1.score >= 1000:
        return die.timesRolled * player2.score

      player2.position = (player2.position + die.roll()) mod 10
      player2.score += player2.position + 1

      if player2.score >= 1000:
        return die.timesRolled * player1.score

  part 2:
    simulate(originalPlayer1, originalPlayer2, 1)
