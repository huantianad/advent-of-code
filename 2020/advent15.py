from aocd import data
from collections import defaultdict

data = [int(x) for x in data.split(',')]

while len(data) < 2020:
    if data[-1] not in set(data[:-1]):
        data.append(0)
    else:
        data.append(data[:-1][::-1].index(data[-1]) + 1)

print(data[2019])


fun_dict = defaultdict(lambda: i)
for x, y in enumerate(data):
    fun_dict[y] = x + 1

num = data[-1]
i = len(data)

while i < 30000000:
    next_num = i - fun_dict[num]
    fun_dict[num] = i
    num = next_num
    i += 1

print(num)
