from aocd import lines

row_ids = [int(seat.replace('B', '1').replace('F', '0').replace('R', '1').replace('L', '0'), 2) for seat in lines]

print(max(row_ids))
print(next(i for i in range(min(row_ids), max(row_ids)+1) if i not in row_ids))
