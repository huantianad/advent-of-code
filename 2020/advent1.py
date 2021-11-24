with open("advent1.txt", "r") as file:
    input_ = list(map(int, file))

print(next(x * y for x in input_ if (y := 2020 - x) in input_))

print(next(x * y * z for x in input_ for y in input_ if (z := 2020 - x - y) in input_))

"""
for i in input_:
    if 2020 - i in input_:
        print(i * (2020 - i))
        break

import itertools
import math

comb = itertools.combinations(input_, 3)
for i in comb:
    if sum(list(i)) == 2020:
        print(math.prod(list(i)))
            
print([math.prod(list(x)) for x in itertools.combinations(input_, 3) if sum(list(x)) == 2020])
"""