from itertools import product

from aocd import data

data = data.split('\n\n')
rules = data[0].split('\n')
messages = data[1].split('\n')
print(messages)

rules = {x.split(": ")[0]: x.split(": ")[1].replace(' ', ',').split(',|,') for x in rules}
rules = {x: [z.replace('"', '').split(',') for z in y] for x, y in zip(rules.keys(), rules.values())}

print(rules)


def recurse(num):
    thing = []
    for rule in rules[num]:
        if rule[0] not in ['a', 'b']:
            try:
                a = recurse(rule[0])
                b = recurse(rule[1])

                prod = product(a, b)

                thing.extend(prod)
            except IndexError:
                thing.extend(rule[0])
        else:
            thing.extend(rule[0])
    return ["".join(x) for x in thing]


print(recurse('0'))
