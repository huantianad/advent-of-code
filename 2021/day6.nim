include aoc

var cache = initTable[(int, int), int]()

proc countFishes(fish: int, turnsLeft: int): int =
  if (fish, turnsLeft) in cache:
    return cache[(fish, turnsLeft)]

  if turnsLeft == 0:
    return 1

  if fish == 0:
    result = countFishes(6, turnsLeft - 1) + countFishes(8, turnsLeft - 1)
    cache[(fish, turnsLeft)] = result
  else:
    result = countFishes(fish - 1, turnsLeft - 1)
    cache[(fish, turnsLeft)] = result

proc countFishes(fish: seq[int], turnsLeft: int): int =
  fish.mapIt(countFishes(it, turnsLeft)).sum

day 6:
  let fishes = input.split(",").map(parseInt)

  part 1:
    countFishes(fishes, 80)
  part 2:
    countFishes(fishes, 256)
