with open("advent5.txt", "r") as file:
    input_ = file.read().split('\n')

row_ids = []

for seat in input_:
    rows = seat[:7]
    cols = seat[7:]

    row_range = range(128)
    for letter in rows:
        middle_index = len(row_range)//2
        if letter == "F":
            row_range = row_range[:middle_index]
        else:
            row_range = row_range[middle_index:]
    row = row_range[0]

    col_range = range(8)
    for letter in cols:
        middle_index = len(col_range)//2
        if letter == "L":
            col_range = col_range[:middle_index]
        else:
            col_range = col_range[middle_index:]
    col = col_range[0]

    row_ids.append(row * 8 + col)

print(max(row_ids))

for i in range(min(row_ids), max(row_ids)+1):
    if i not in row_ids:
        print(i)

