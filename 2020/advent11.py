from aocd import lines


def run_lines(lines):
    new_lines = []

    for idl, row in enumerate(lines):
        new_row = []

        for idr, seat in enumerate(row):
            if seat == ".":
                new_row.append(".")

            elif seat == "L":
                if ((lines[idl - 1][idr] != "#" if 0 <= (idl - 1) < 90 else True) and
                        (lines[idl + 1][idr] != "#" if 0 <= (idl + 1) < 90 else True) and
                        (lines[idl][idr + 1] != "#" if 0 <= (idr + 1) < 99 else True) and
                        (lines[idl][idr - 1] != "#" if 0 <= (idr - 1) < 99 else True) and
                        (lines[idl + 1][idr + 1] != "#" if 0 <= (idl + 1) < 90 and 0 <= (idr + 1) < 99 else True) and
                        (lines[idl - 1][idr + 1] != "#" if 0 <= (idl - 1) < 90 and 0 <= (idr + 1) < 99 else True) and
                        (lines[idl - 1][idr - 1] != "#" if 0 <= (idl - 1) < 90 and 0 <= (idr - 1) < 99 else True) and
                        (lines[idl + 1][idr - 1] != "#" if 0 <= (idl + 1) < 90 and 0 <= (idr - 1) < 99 else True)):
                    new_row.append("#")
                else:
                    new_row.append("L")

            elif seat == "#":
                if ((int(lines[idl - 1][idr] == "#" if 0 <= (idl - 1) < 90 else False) +
                        int(lines[idl + 1][idr] == "#" if 0 <= (idl + 1) < 90 else False) +
                        int(lines[idl][idr + 1] == "#" if 0 <= (idr + 1) < 99 else False) +
                        int(lines[idl][idr - 1] == "#" if 0 <= (idr - 1) < 99 else False) +
                        int(lines[idl + 1][idr + 1] == "#" if 0 <= (idl + 1) < 90 and 0 <= (idr + 1) < 99 else False) +
                        int(lines[idl - 1][idr + 1] == "#" if 0 <= (idl - 1) < 90 and 0 <= (idr + 1) < 99 else False) +
                        int(lines[idl - 1][idr - 1] == "#" if 0 <= (idl - 1) < 90 and 0 <= (idr - 1) < 99 else False) +
                        int(lines[idl + 1][idr - 1] == "#" if 0 <= (idl + 1) < 90 and 0 <= (idr - 1) < 99 else False)) > 3):
                    new_row.append("L")
                else:
                    new_row.append("#")

        new_lines.append(new_row)
    return new_lines


while True:
    temp = run_lines(lines)
    if temp == lines:
        print(len(["#" for row in lines for seat in row if seat == "#"]))
        break
    else:
        lines = temp


def run_lines2(lines):
    new_lines = []

    for idl, row in enumerate(lines):
        new_row = []

        for idr, seat in enumerate(row):
            if seat == ".":
                new_row.append(".")

            elif seat == "L":
                if ([(x != "#") for i in range(1, idl) if ((x := lines[idl - i][idr]) in ("L", "#") if 0 <= (idl - i) < 90 else True)]and
                    [(x != "#") for i in range(1, idl) if ((x := lines[idl + 1][idr]) in ("L", "#") if 0 <= (idl + i) < 90 else True)] and
                    [(x != "#") for i in range(1, idr) if ((x := lines[idl][idr - 1]) in ("L", "#") if 0 <= (idr - i) < 90 else True)] and
                    [(x != "#") for i in range(1, idr) if ((x := lines[idl][idr + 1]) in ("L", "#") if 0 <= (idr + i) < 90 else True)] and
                    [(x != "#") for i in range(1, idl if idr > idl else idr) if ((x := lines[idl - i][idr - i]) in ("L", "#") if 0 <= (idl - i) < 90 and 0 <= (idr - i) < 99 else True)] and
                    [(x != "#") for i in range(1, idl if idr > idl else idr) if ((x := lines[idl - i][idr + i]) in ("L", "#") if 0 <= (idl - i) < 90 and 0 <= (idr + i) < 99 else True)] and
                    [(x != "#") for i in range(1, idl if idr > idl else idr) if ((x := lines[idl + i][idr - i]) in ("L", "#") if 0 <= (idl + i) < 90 and 0 <= (idr - i) < 99 else True)] and
                    [(x != "#") for i in range(1, idl if idr > idl else idr) if ((x := lines[idl + i][idr + i]) in ("L", "#") if 0 <= (idl + i) < 90 and 0 <= (idr + i) < 99 else True)]):
                    new_row.append("#")
                else:
                    new_row.append("L")

            elif seat == "#":
                if ((int(lines[idl - 1][idr] == "#" if 0 <= (idl - 1) < 90 else False) +
                     int(lines[idl + 1][idr] == "#" if 0 <= (idl + 1) < 90 else False) +
                     int(lines[idl][idr + 1] == "#" if 0 <= (idr + 1) < 99 else False) +
                     int(lines[idl][idr - 1] == "#" if 0 <= (idr - 1) < 99 else False) +
                     int(lines[idl + 1][idr + 1] == "#" if 0 <= (idl + 1) < 90 and 0 <= (idr + 1) < 99 else False) +
                     int(lines[idl - 1][idr + 1] == "#" if 0 <= (idl - 1) < 90 and 0 <= (idr + 1) < 99 else False) +
                     int(lines[idl - 1][idr - 1] == "#" if 0 <= (idl - 1) < 90 and 0 <= (idr - 1) < 99 else False) +
                     int(lines[idl + 1][idr - 1] == "#" if 0 <= (idl + 1) < 90 and 0 <= (idr - 1) < 99 else False)) > 4):
                    new_row.append("L")
                else:
                    new_row.append("#")

        new_lines.append(new_row)
    return new_lines


while True:
    temp = run_lines2(lines)
    print(temp)
    if temp == lines:
        print(len(["#" for row in lines for seat in row if seat == "#"]))
        break
    else:
        lines = temp
