from aocd import lines
print(lines)

i = 0
line_num = 0
lined = []


def execute(instruction, line):
    global i
    if instruction.startswith('nop'):
        return line + 1
    elif instruction.startswith('acc'):
        i += int(instruction[4:])
        return line + 1
    elif instruction.startswith('jmp'):
        return line + int(instruction[4:])


while True:
    line_num = execute(lines[line_num], line_num)
    if line_num in lined:
        print(i)
        break
    else:
        lined.append(line_num)


for idx, line in enumerate(lines):
    if not line.startswith('acc'):
        temp_lines = [x for x in lines]
        temp_lines[idx] = f'nop {line[4:]}' if line.startswith('jmp') else f'jmp {line[4:]}'

        i = 0
        line_num = 0
        lined = []

        while True:
            try:
                line_num = execute(temp_lines[line_num], line_num)
                if line_num in lined:
                    break
                else:
                    lined.append(line_num)
            except IndexError:
                print(i)
                break
