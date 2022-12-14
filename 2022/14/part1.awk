BEGIN {
    FS = "[^0-9]+"
    startx = 500 # ; starty = maxy = 0
}
{
    x = $1 ; y = $2
    for (i = 1 ; i <= NF ; i+=2){
        fill_line(x, y, $i, $(i+1))
        x = $i ; y = $(i+1)
	if (y > maxy) maxy = y
    }
}
END {
    do {
	x = startx ; y = starty
        for( ; y < maxy ; y++) {
	    if (! (x SUBSEP y+1 in filled)) {
		continue
	    } else if (! (x-1 SUBSEP y+1 in filled)) {
		x--; continue
	    } else if (! (x+1 SUBSEP y+1 in filled)) {
		x++; continue
	    } else {
		break
	    }
	}
	if (y < maxy) {
	    filled[x,y]
	    n++
	}
    } while (y < maxy)
    print n
}

function fill_line(x1, y1, x2, y2,    dx, dy) {
    dx = sign(x2 - x1) ; dy = sign(y2 - y1)  
    while (x2 != x1 || y2 != y1) {
	filled[x1,y1]
	x1 += dx ; y1 += dy
    }
    filled[x2,y2]
}

function sign(a) { return a < 0 ? -1 : (a > 0 ? 1 : 0) }
