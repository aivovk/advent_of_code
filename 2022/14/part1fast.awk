BEGIN { FS = "[^0-9]+" }
{
    x = $1 ; y = $2
    for (i = 1 ; i <= NF ; i+=2){
        fill_rock(x, y, $i, $(i+1))
        x = $i ; y = $(i+1)
	if (y > maxy) maxy = y
    }
}
END { fill_sand(500, 0) }

function fill_sand(x, y) { # GLOBALS: n_sand, maxy, filled
    if (y == maxy) { print n_sand ; exit }
    if (! (x SUBSEP y+1 in filled)) fill_sand(x, y+1)
    if (! (x-1 SUBSEP y+1 in filled)) fill_sand(x-1, y+1)
    if (! (x+1 SUBSEP y+1 in filled)) fill_sand(x+1, y+1)
    filled[x,y]
    n_sand++
    return
}

function fill_rock(x1, y1, x2, y2,    dx, dy) { # fill a line from 1 to 2
    dx = sign(x2 - x1) ; dy = sign(y2 - y1)
    while (x2 != x1 || y2 != y1) {
	filled[x1,y1]
	x1 += dx ; y1 += dy
    }
    filled[x2,y2]
}

function sign(a) { return a < 0 ? -1 : (a > 0 ? 1 : 0) }
