from aocd import lines
from sympy.ntheory.modular import crt

ids = {int(idy): int(idy) - int(idx) for idx, idy in enumerate(lines[1].split(',')) if idy != 'x'}
print({idx: idx - (int(lines[0]) % idx) for idx in ids})
print(crt(ids.keys(), ids.values()))
