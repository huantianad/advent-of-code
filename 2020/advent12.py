from aocd import lines

position = [0, 0]
facing = 0

for line in lines:
    action = line[0]
    value = int(line[1:])

    if action == "N":
        position[1] += value
    elif action == "S":
        position[1] -= value
    elif action == "E":
        position[0] += value
    elif action == "W":
        position[0] -= value

    elif action == "L":
        facing += value
        facing = facing % 360
    elif action == "R":
        facing -= value
        facing = facing % 360

    elif action == "F":
        if facing == 0:
            position[0] += value
        elif facing == 90:
            position[1] += value
        elif facing == 180:
            position[0] -= value
        elif facing == 270:
            position[1] -= value

print(sum([abs(x) for x in position]))

waypoint = [10, 1]
position = [0, 0]

for line in lines:
    action = line[0]
    value = int(line[1:])

    if action == "N":
        waypoint[1] += value
    elif action == "S":
        waypoint[1] -= value
    elif action == "E":
        waypoint[0] += value
    elif action == "W":
        waypoint[0] -= value

    elif action == "L":
        if value == 0:
            pass
        elif value == 90:
            waypoint[0], waypoint[1] = -waypoint[1], waypoint[0]
        elif value == 180:
            waypoint[0], waypoint[1] = -waypoint[0], -waypoint[1]
        elif value == 270:
            waypoint[0], waypoint[1] = waypoint[1], -waypoint[0]

    elif action == "R":
        if value == 0:
            pass
        elif value == 90:
            waypoint[0], waypoint[1] = waypoint[1], -waypoint[0]
        elif value == 180:
            waypoint[0], waypoint[1] = -waypoint[0], -waypoint[1]
        elif value == 270:
            waypoint[0], waypoint[1] = -waypoint[1], waypoint[0]

    elif action == "F":
        position[0], position[1] = position[0] + value * waypoint[0], position[1] + value * waypoint[1]

print(sum([abs(x) for x in position]))
