from collections import Counter
from itertools import combinations
from math import prod

from aocd import numbers

input_ = sorted(numbers)
input_.append(input_[-1]+3)
input_.insert(0, 0)

print(Counter([input_[idx + 1] - num for idx, num in enumerate(input_[:-1])]))


split = []
looped = []
for idx, num in enumerate(input_[:-1]):
    if input_[idx + 1] - num == 3:
        value = input_[len(looped):idx + 1]
        split.append(value)
        looped.extend(value)


big_thing = []
for chunk in split:
    if len(chunk) > 2:
        combs = []
        for i in range(len(chunk)):
            combs.extend(combinations(chunk[1:-1], i))
        new_combs = []
        for com in combs:
            temp_com = list(com)
            temp_com.insert(0, chunk[0])
            temp_com.append(chunk[-1])
            new_combs.append(temp_com)
        counter = 0
        for thing in new_combs:
            if not [True for idx, num in enumerate(thing[:-1]) if thing[idx + 1] - num not in range(1, 4)]:
                counter += 1
        big_thing.append(counter)

print(prod(big_thing))
