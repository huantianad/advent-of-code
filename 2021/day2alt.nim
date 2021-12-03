var x, y, depth: int

proc up(mag: int) = y -= mag
proc down(mag: int) = y += mag
proc forward(mag: int) = x += mag; depth += y * mag

include "../aocNim/inputs/day2.in"

echo x * y, ' ', x * depth
