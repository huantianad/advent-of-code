include aoc

let openToClose = {'{': '}', '(': ')', '[': ']', '<': '>'}.toTable
let scores1 = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
let scores2 = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

day 10:
  var score1: int
  var score2: seq[int]

  for line in lines:
    var expected = initDeque[char]()

    block check:
      for bracket in line:
        if bracket in openToClose:
          expected.addLast(openToClose[bracket])
        elif bracket != expected.popLast:
          score1 += scores1[bracket]
          break check

      var score: int

      for bracket in expected.toSeq.reversed:
        score *= 5
        score += scores2[bracket]

      score2.add(score)

  part 1:
    score1
  part 2:
    score2.sorted[(score2.len - 1) div 2]
