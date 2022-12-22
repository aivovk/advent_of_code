BEGIN {
    FS = ""
    dcol[0] = 1
    drow[1] = 1
    dcol[2] = -1
    drow[3] = -1
    n_dirs = 4
    data = "map"
}
NF == 0 { maxrow = NR - 1 ; side = max(maxrow, maxcol) / 4 ; data = "path" ; next }
data == "map" {
    for (col = 1 ; col <= NF ; col++){
	if (!startcol && $col != " ") startcol = col - 1
	if ($col != " ") map[NR-1, col-1] = $col
    }
    if (NF > maxcol) maxcol = NF
    next
}
data == "path" {
    row = 0 ; col = startcol ; facing = 0
    do{
	nextrow = row
	nextcol = col
	nextfacing = facing
	match($0, /^([0-9]+)([RL])?/, arr)
	steps = arr[1]
	while (steps > 0){
	    nextrow += drow[nextfacing]
	    nextcol += dcol[nextfacing]
	    if (!(nextrow SUBSEP nextcol in map)){
	        nextregion = get_region(nextrow, nextcol)
		region = get_region(row, col)
		if (nextrow < 0 && region == 2) {
		    nextrow = 3 * side + nextcol % side
		    nextcol = 0
		    nextfacing = 0
		} else if (nextrow < 0 && region == 3) {
		    nextcol = nextcol % side
		    nextrow = maxrow - 1
		    nextfacing = 3
		} else if (nextregion == 1) {
		    nextrow = 3 * side - 1 - nextrow
		    nextcol = 0
		    nextfacing = 0
		} else if (nextcol >= maxcol) {
		    nextrow = 3 * side - 1 - nextrow
		    nextcol = 2 * side - 1
		    nextfacing = 2
		} else if (nextregion == 6 && region == 3) {
		    nextrow = side + nextcol % side
		    nextcol = 2 * side - 1
		    nextfacing = 2
		} else if (nextregion == 4 && region == 5) {
		    nextcol = nextrow % side
		    nextrow = 2 * side
		    nextfacing = 1
		} else if (nextregion == 6 && region == 5) {
		    nextcol = 2 * side + nextrow % side
		    nextrow = side - 1
		    nextfacing = 3
		} else if (nextregion == 4 && region == 7) {
		    nextrow = side + nextcol
		    nextcol = side
		    nextfacing = 0		    
		} else if (nextcol < 0 && region == 7) {
		    nextrow = side - 1 - nextrow % side
		    nextcol = side
		    nextfacing = 0
		} else if (nextregion == 9) {
		    nextcol = 3 * side - 1
		    nextrow = side - 1 - nextrow % side
		    nextfacing = 2
		} else if (nextregion == 11 && region == 8) {
		    nextrow = 3 * side + nextcol % side
		    nextcol = side - 1
		    nextfacing = 2
		} else if (nextcol < 0 && region == 10) {
		    nextcol = side + nextrow % side
		    nextrow = 0
		    nextfacing = 1
		} else if (nextregion == 11 && region == 10) {
		    nextcol = side + nextrow % side
		    nextrow = 3 * side - 1
		    nextfacing = 3
		} else if (nextrow >= maxrow) {
		    nextrow = 0
		    nextcol = 2 * side + nextcol
		    nextfacing = 1
		} else {
		    print "ERROR: UNREACHABLE"
		    exit
		}
	    }
	    if (map[nextrow,nextcol] == "#") break
	    if (map[nextrow,nextcol] == "."){
		steps--
		row = nextrow ; col = nextcol ; facing = nextfacing
	    }
	}
	if (2 in arr)
	    facing = (n_dirs + facing + (arr[2] == "R" ? 1 : -1 )) % n_dirs
    } while (sub(/^[0-9]+[RL]/, ""))
    print 1000 * (row+1) + 4 * (col+1) + facing
}

function get_region(r, c) { # regions are numbered from 1 to 12 (a 4x3 grid of faces)
    if (r < 0 || c < 0 || c >= maxcol || r >= maxrow) return 0 # out of bounds
    return 1 + div(c, side) + 3 * div(r, side)
}

function div(a, b) { return (a - (a % b)) / b } # no remainder

function max(a, b) { return a > b ? a : b }
