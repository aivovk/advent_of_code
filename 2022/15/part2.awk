@include "range.awk"
# very slow
BEGIN {
    FS = "[^0-9-]+"
    minxy = 0
    maxxy = 4000000 # maxxy=20 for test
    for (y = minxy ; y <= maxxy ; y++)
	ranges[y]
}
{
    sx = $2
    sy = $3
    bx = $4
    by = $5
    d = abs(sx-bx) + abs(sy-by)
    for (y = max(sy - d, minxy) ; y <= min(sy + d, maxxy) ; y ++){
	if (y in ranges) {
	    dx = d - abs(y - sy)
	    ranges[y] = update_range(ranges[y], max(sx - dx, minxy), min(sx + dx, maxxy))
	    if (start(ranges[y]) <= minxy && end(ranges[y]) >= maxxy)
		delete ranges[y]
	}
    }
}
END {
    for (y in ranges)
	print y + 4000000 * (end(ranges[y]) + 1)
}
