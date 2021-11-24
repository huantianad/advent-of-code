with open("advent2.txt", "r") as file:
    input_ = file.read().split('\n')


modified_input = [[int((a := x.split('-'))[0]), int((b := a[1].split(' ', 1))[0]), b[1].split(': ')[0], b[1].split(': ')[1]] for x in input_]

correct_passwords = [x for x in modified_input if x[0] <= x[3].count(x[2]) <= x[1]]
print(len(correct_passwords))

correct_passwords2 = [x for x in modified_input if x[3][x[0]-1].count(x[2]) + x[3][x[1]-1].count(x[2]) == 1]
print(len(correct_passwords2))
