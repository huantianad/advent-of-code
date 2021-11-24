from aocd import lines

data = dict([((x := line.split(' bags contain '))[0], dict([y.split(' ', 1)[::-1] for y in x[1].replace(' bags', '').replace(' bag', '').replace('.', '').split(', ')])) for line in lines])


def check(bag):
    for x in data[bag]:
        if x == "shiny gold":
            return True
    return any([check(x) for x in data[bag] if not x == 'other'])


print(len([bag for bag in data if check(bag)]))


def count(bag):
    if 'other' in data[bag].keys():
        return 1
    counter = 1
    for x in data[bag]:
        counter += int(data[bag][x]) * count(x)
    return counter


print(count('shiny gold') - 1)
