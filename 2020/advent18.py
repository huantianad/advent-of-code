from re import sub

from aocd import lines


class Num(int):
    def __sub__(self, x):
        return Num(int(self) * x)

    def __add__(self, x):
        return Num(int(self) + x)

    def __mul__(self, x):
        return Num(int(self) + x)


def evaluate(line, p2=False):
    line = line.replace("*", "-")
    if p2:
        line = line.replace("+", "*")
    line = sub(r'(\d+)', r'Num(\1)', line)
    return eval(line)


print(sum(evaluate(line) for line in lines))
print(sum(evaluate(line, True) for line in lines))
