from math import prod

from aocd import lines

rules = lines[:20]
ranges = [[(int(x.split('-')[0]), int(x.split('-')[1])) for x in rule.split(': ')[1].split(' or ')] for rule in rules]
my_ticket = [int(x) for x in lines[22].split(',')]
nearby_tickets = [[int(y) for y in x.split(',')] for x in lines[25:]]


def check(value):
    for range_ in ranges:
        yield (range_[0][0] <= value <= range_[0][1]) or (range_[1][0] <= value <= range_[1][1])


print(sum([num for ticket in nearby_tickets for num in ticket if not any(check(num))]))

nearby_tickets = [ticket for ticket in nearby_tickets if all([True if any(check(num)) else False for num in ticket])]
zipped = zip(*nearby_tickets)

stuff = []
for field in zipped:
    check_return = [check(value) for value in field]
    stuff.append([all(x) for x in zip(*check_return)])


answer_dict = {}
while len(answer_dict) < 20:
    recent = 0
    for index, x in enumerate(stuff):
        if sum(x) == 1:
            answer_dict[x.index(True)] = index
            recent = x.index(True)
    for x in stuff:
        x[recent] = 0

print(prod(my_ticket[answer_dict[x]] for x in range(6)))
