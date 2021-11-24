from aocd import lines
from collections import Counter

mem = {}
mask = ""

for line in lines:
    if line.startswith("mask"):
        mask = line[7:]
    else:
        value = bin(int(line.split(" = ")[1]))[2:]
        index = int(line.split("]")[0][4:])

        masked_value = []
        for idx, num in enumerate(mask[::-1]):
            if num == "X":
                if idx >= len(value):
                    masked_value.append("0")
                else:
                    masked_value.append(value[::-1][idx])
            else:
                masked_value.append(str(num))
        mem[index] = int("".join(masked_value[::-1]), 2)

print(sum(mem.values()))

mem = {}
mask = ""
x_count = 0


for line in lines:
    if line.startswith("mask"):
        mask = line[7:]
        x_count = Counter(mask)['X']
    else:
        value = int(line.split(" = ")[1])
        index = bin(int(line.split("]")[0][4:]))[2:]

        masked_index = []
        for idx, num in enumerate(mask[::-1]):
            if num == "X":
                masked_index.append("X")
            elif num == "1":
                masked_index.append("1")
            elif num == "0":
                if idx >= len(index):
                    masked_index.append("0")
                else:
                    masked_index.append(index[::-1][idx])

        all_index = ["".join(masked_index[::-1])]
        for x in range(x_count):
            temp_list = []
            temp_list.extend(all_index)
            all_index = []
            for stuff in temp_list:
                for i in ["0", "1"]:
                    all_index.append(stuff.replace("X", i, 1))

        all_index = [int(x, 2) for x in all_index]

        for x in all_index:
            mem[x] = value

print(sum(mem.values()))
