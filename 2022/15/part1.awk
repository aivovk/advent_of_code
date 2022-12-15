# slow
BEGIN {
    FS = "[^0-9-]+"
    y = 2000000 # y=10 for test
}
{
    sx = $2 ; sy = $3 ; bx = $4 ; by = $5
    d = abs(sx-bx) + abs(sy-by)
    dx = d - abs(y - sy)
    if (dx >= 0)
	for (x = sx - dx ; x <= sx + dx ; x++)
	    nobeacon[x]
    if (by == y)
	beacon[bx]
}
END { print length(nobeacon) - length(beacon) }

function abs(a) { return a < 0 ? -a : a }
