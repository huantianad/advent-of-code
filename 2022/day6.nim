include aoc

day 6:
  part 1:
    for i in 4..input.len:
      if input[i-4..<i].toSet.len == 4:
        return i
  part 2:
    for i in 14..input.len:
      if input[i-14..<i].toSet.len == 14:
        return i
