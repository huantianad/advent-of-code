with open("advent6.txt", "r") as file:
    input_ = [x.split('\n') for x in file.read().split('\n\n')]

new_input = [set(''.join(group)) for group in input_]
print(sum([len(x) for x in new_input]))

# newer_input = [[letter for letter in set(''.join(group)) if all(letter in x for x in group)] for group in input_]

# newer_input = [(x := [set(item) for item in group])[0].intersection(*x[1:]) for group in input_]

sets = [[set(item) for item in group] for group in input_]
newer_input = [group[0].intersection(*group[1:]) for group in sets]
print(sum([len(x) for x in newer_input]))
