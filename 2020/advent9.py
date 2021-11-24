from itertools import combinations

from aocd import numbers

answer = 0


def get_combs(list_):
    for w in range(1, len(list_)+1):
        for i in range(len(list_)-w+1):
            yield list_[i:i+w]


for idx, number in enumerate(numbers[25:]):
    combination = combinations(numbers[idx:idx+25], 2)
    combination = [sum(x) for x in combination]
    if number not in combination:
        answer = number
        print(answer)
        break

combs = get_combs(numbers)
print([min(x) + max(x) for x in combs if sum(x) == answer and x[0] != answer][0])
