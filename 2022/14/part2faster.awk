BEGIN { FS = "[^0-9]+" }
{
    x = $1 ; y = $2
    for (i = 1 ; i <= NF ; i+=2){
        fill_line(x, y, $i, $(i+1))
        x = $i ; y = $(i+1)
	if (y > maxy) maxy = y
    }
}
END {
    floor = maxy + 2
    sand[startx=500, starty=0]
    for (y = starty + 1 ; y < floor ; y++)
	for (x = startx - y ; x <= startx + y ; x++)
	    if (!(x SUBSEP y in rock) &&
		(x-1 SUBSEP y-1 in sand || x SUBSEP y-1 in sand || x+1 SUBSEP y-1 in sand))
		sand[x SUBSEP y]
    print length(sand)
}

function fill_line(x1, y1, x2, y2,    dx, dy) { # fill a line from 1 to 2
    dx = sign(x2 - x1) ; dy = sign(y2 - y1)
    while (x2 != x1 || y2 != y1) {
	rock[x1,y1]
	x1 += dx ; y1 += dy
    }
    rock[x2,y2]
}

function sign(a) { return a < 0 ? -1 : (a > 0 ? 1 : 0) }
