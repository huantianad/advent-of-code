include aoc

proc pretty(input: seq[seq[char]]): string =
  input.mapIt($it.join).join("\n")

proc step(input: seq[seq[char]]): seq[seq[char]] =
  var tempResult = input

  for rowNum, row in input:
    for colNum, cumb in row:
      let nextSpace = (colNum + 1) mod row.len
      if cumb == '>' and input[rowNum][nextSpace] == '.':
        tempResult[rowNum][nextSpace] = '>'
        tempResult[rowNum][colNum] = '.'

  result = tempResult

  for rowNum, row in tempResult:
    for colNum, cumb in row:
      let nextSpace = (rowNum + 1) mod input.len
      if cumb == 'v' and tempResult[nextSpace][colNum] == '.':
        result[nextSpace][colNum] = 'v'
        result[rowNum][colNum] = '.'

day 25:
  let parsed = lines.mapIt(it.toSeq)

  var states = @[parsed]
  while true:
    states.add(states[^1].step)
    if states[^1] == states[^2]:
      break

  part 1:
    states.len - 1
