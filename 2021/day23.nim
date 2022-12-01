include aoc

type
  Space = enum
    `.`, A, B, C, D

  Move = tuple
    start, finish: Position

  PositionKind = enum
    Hallway, Room

  Position = object of RootObj
    case kind: PositionKind
    of Hallway: hall: range[0..6]
    of Room: room: (range[0..3], range[0..1])
    # (room num, room y)
    #0 0
    #1 1

  Structure = object of RootObj
    rooms: array[4, array[2, Space]]
    hallway: array[7, Space]

proc toStructure(lines: seq[string]): Structure =
  for i in 0..3:
    result.rooms[i] = [parseEnum[Space]($lines[2][i * 2 + 3]), parseEnum[Space]($lines[3][i * 2 + 3])]

proc `[]`(struct: Structure, pos: Position): Space =
  case pos.kind:
  of Hallway:
    struct.hallway[pos.hall]
  of Room:
    struct.rooms[pos.room[0]][pos.room[1]]

proc `[]=`(struct: var Structure, pos: Position, space: Space) =
  case pos.kind:
  of Hallway:
    struct.hallway[pos.hall] = space
  of Room:
    struct.rooms[pos.room[0]][pos.room[1]] = space

proc initPos(hall: int): Position =
  Position(kind: Hallway, hall: hall)

proc initPos(room: (range[0..3], range[0..1])): Position =
  Position(kind: Room, room: room)

proc initPos(roomNum: range[0..3], roomY: range[0..1]): Position =
  Position(kind: Room, room: (roomNum, roomY))


proc `$`(pos: Position): string =
  if pos.kind == Hallway:
    fmt"h{pos.hall}"
  else:
    fmt"r{pos.room}"

proc `$`(input: Move): string =
  fmt"({input.start} -> {input.finish})"

proc add(self: var seq[Move], start: Position, finish: Position) =
  self.add((start, finish))

proc hallEmptyAt(struct: Structure, points: varargs[int]): bool =
  for point in points:
    if struct.hallway[point] != `.`:
      return false
  return true


proc validMove(struct: Structure, move: Move): bool =
  let (start, finish) = move

  if start.kind == Hallway:
    if finish.kind == Hallway:
      # echo "THIS SHOULD NOT HAPPEN, attempted to move from hall->hall"
      return false

    const enumToRoomIndex = {A: 0, B: 1, C: 2, D: 3}.toTable
    if finish.room[0] != enumToRoomIndex[struct[start]]:
      # echo fmt"attempting to move to incorrect room, {struct[start]} cannot move to {finish.room[0]}"
      return false

    if struct[finish] != `.`:
      return false

    # If we don't clear the start, validMove will fail, because it thinks there's something there
    var betterStruct = struct
    betterStruct[start] = `.`

    return validMove(betterStruct, (finish, start))

  let (startRoomNum, startRoomY) = start.room

  # check if this isn't blocked in the room by something above
  for i in 0..<startRoomY:
    if struct.rooms[startRoomNum][i] != `.`:
      return false

  if finish.kind == Hallway:
    case startRoomNum:
    of 0:
      case finish.hall:
      of 0: return struct.hallEmptyAt(0, 1)
      of 1: return struct.hallEmptyAt(1)
      of 2: return struct.hallEmptyAt(2)
      of 3: return struct.hallEmptyAt(2, 3)
      of 4: return struct.hallEmptyAt(2, 3, 4)
      of 5: return struct.hallEmptyAt(2, 3, 4, 5)
      of 6: return struct.hallEmptyAt(2, 3, 4, 5, 6)
    of 1:
      case finish.hall:
      of 0: return struct.hallEmptyAt(0, 1, 2)
      of 1: return struct.hallEmptyAt(1, 2)
      of 2: return struct.hallEmptyAt(2)
      of 3: return struct.hallEmptyAt(3)
      of 4: return struct.hallEmptyAt(3, 4)
      of 5: return struct.hallEmptyAt(3, 4, 5)
      of 6: return struct.hallEmptyAt(3, 4, 5, 6)
    of 2:
      case finish.hall:
      of 0: return struct.hallEmptyAt(0, 1, 2, 3)
      of 1: return struct.hallEmptyAt(1, 2, 3)
      of 2: return struct.hallEmptyAt(2, 3)
      of 3: return struct.hallEmptyAt(3)
      of 4: return struct.hallEmptyAt(4)
      of 5: return struct.hallEmptyAt(4, 5)
      of 6: return struct.hallEmptyAt(4, 5, 6)
    of 3:
      case finish.hall:
      of 0: return struct.hallEmptyAt(0, 1, 2, 3, 4)
      of 1: return struct.hallEmptyAt(1, 2, 3, 4)
      of 2: return struct.hallEmptyAt(2, 3, 4)
      of 3: return struct.hallEmptyAt(3, 4)
      of 4: return struct.hallEmptyAt(4)
      of 5: return struct.hallEmptyAt(5)
      of 6: return struct.hallEmptyAt(5, 6)
  else:
    let (finishRoomNum, finishRoomY) = finish.room
    if finishRoomNum == startRoomNum:
      # echo "going to same room, always bad"
      return false

    # Checking if the finishing room is blocked
    for i in 0..finishRoomY:
      if struct.rooms[finishRoomNum][i] != `.`:
        return false

    # check if the finish room is the correct room for the thing moving
    const enumToRoomIndex = {A: 0, B: 1, C: 2, D: 3}.toTable
    if finish.room[0] != enumToRoomIndex[struct[start]]:
      # echo fmt"attempting to move to incorrect room, {struct[start]} cannot move to {finish.room[0]}"
      return false

    let finishIsRightOfStart = finishRoomNum > startRoomNum
    let almostEqualHall =
      if finishIsRightOfStart:
        finishRoomNum - 1
      else:
        finishRoomNum + 2

    return validMove(struct, (start, initPos(almostEqualHall)))

proc allPositions(): seq[Position] =
  for i in 0..6:
    result.add(initPos(i))

  for roomNum in 0..3:
    for roomY in 0..1:
      result.add(initPos(roomNum, roomY))

proc generateMoves(input: Structure): seq[Move] =
  for start in allPositions():
    # make sure the starting position actually has something to move
    if input[start] == `.`:
      continue

    for finish in allPositions():
      if validMove(input, (start, finish)):
        result.add(start, finish)

proc distance(move: Move): int =
  let (start, finish) = move

  const toTrueHallway = {0: 0, 1: 1, 2: 3, 3: 5, 4: 7, 5: 9, 6: 10}.toTable
  const roomToHallway = {0: 2, 1: 4, 2: 6, 3: 8}.toTable

  if start.kind == Hallway and finish.kind == Hallway:
    return abs(toTrueHallway[start.hall] - toTrueHallway[finish.hall])
  elif start.kind == Hallway and finish.kind == Room:
    return distance((finish, start))
  elif start.kind == Room and finish.kind == Hallway:
    return start.room[1] + 1 + abs(roomToHallway[start.room[0]] - toTrueHallway[finish.hall])
  elif start.kind == Room and finish.kind == Hallway:
    return start.room[1] + 1 + finish.room[1] + 1 + abs(roomToHallway[start.room[0]] - roomToHallway[finish.room[0]])

proc isDone(struct: Structure): bool =
  const enumToRoomIndex = {A: 0, B: 1, C: 2, D: 3}.toTable
  for space, roomNum in enumToRoomIndex.pairs:
    if not struct.rooms[roomNum].allIt(it == space):
      return false

  return true

var cache = initTable[Structure, int]()

proc recurse(struct: Structure, previousStructs: seq[Structure] = @[]): int =
  if struct in cache:

    return cache[struct]

  # echo struct
  if struct.isDone:
    return 0

  let newPreviousStructs = previousStructs & @[struct]
  var values: seq[int]

  for start, finish in struct.generateMoves().items:
    let thingMoving = struct[start]
    var newStruct = struct

    newStruct[start] = `.`
    newStruct[finish] = thingMoving

    if newStruct in previousStructs:
      continue

    values.add(recurse(newStruct, newPreviousStructs) + distance((start, finish)))

  if values.len != 0:
    result = values.min
    result = 9999999

  cache[struct] = result


day 23:
  var initial = lines.toStructure
  echo initial.recurse

  # initial.hallway[0] = A
  # initial.hallway[1] = B
  # initial.rooms[0][0] = `.`
  # echo initial

  # echo initial.generateMoves

  part 1:
    "Part 1 solution"
  part 2:
    "Part 2 solution"
