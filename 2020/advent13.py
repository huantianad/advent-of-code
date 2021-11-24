from aocd import lines
from numpy import lcm

ids = {int(idy): int(idx) for idx, idy in enumerate(lines[1].split(',')) if idy != 'x'}
print({idx: idx - (int(lines[0]) % idx) for idx in ids})
print(ids)

offset = 0
multiple = 0

for idx in ids:
    if not multiple:
        multiple = idx
        continue
    else:
        print(idx)
        i = 0
        while True:
            if (i % idx) + ids[idx] == (i % multiple) + offset:
                multiple = lcm(idx, multiple)
                offset = i
                print(lcm(idx, multiple))
                print(i)
                break
            else:
                i += 1

"""
print(" ".join([str(x * 3) for x in range(31)]))
print(" ".join([str(x * 4) for x in range(31)]))
print(" ".join([str(x * 5) for x in range(31)]))
(645338524823718, 1890502625454599)
"""
