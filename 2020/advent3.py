from math import prod

with open("advent3.txt", "r") as file:
    input_ = file.read().split('\n')


def count(r, d):
    return len([i for i, row in enumerate(input_[d::d]) if row[(i * r + r) % 31] == "#"])


print([count(r, d) for r, d in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]])

print(prod([len([i for i, row in enumerate(input_[d::d]) if row[(i * r + r) % 31] == "#"]) for r, d in
            [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]]))

# r1d1
counter = 0

for i, row in enumerate(input_[1:]):
    if row[(i + 1) % 31] == "#":
        counter += 1

print(counter)

# r3d1
counter = 0

for i, row in enumerate(input_[1:]):
    if row[(i * 3 + 3) % 31] == "#":
        counter += 1

print(counter)

# r5d1
counter = 0

for i, row in enumerate(input_[1:]):
    if row[(i * 5 + 5) % 31] == "#":
        counter += 1

print(counter)

# r7d1
counter = 0

for i, row in enumerate(input_[1:]):
    if row[(i * 7 + 7) % 31] == "#":
        counter += 1

print(counter)

# r1d2
counter = 0

for i, row in enumerate(input_[2::2]):
    if row[(i + 1) % 31] == "#":
        counter += 1

print(counter)
