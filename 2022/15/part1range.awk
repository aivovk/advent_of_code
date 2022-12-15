@include "range.awk"
# using the range logic from part2.awk
BEGIN {
    FS = "[^0-9-]+"
    y = 2000000 # y=10 for test
}
{
    sx = $2 ; sy = $3 ; bx = $4 ; by = $5
    d = abs(sx-bx) + abs(sy-by)
    dx = d - abs(y - sy)
    if (dx >= 0)
	ranges = update_range(ranges, sx - dx, sx + dx)
    if (by == y)
	beacon[bx]
}
END { print sum(ranges) - length(beacon) }
