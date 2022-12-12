BEGIN {
    FS = ""
    for(;i<256;i++) ord[sprintf("%c",i)]=i
    drow[0] = -1 ; drow[1] = 1
    dcol[2] = -1 ; dcol[3] = 1
}
NR == 1 { cols = NF }
{
    len[NR,0] = len[NR,cols+1] = -1 # pad the sides
    for (col = 1 ; col <= cols ; col++){
	loc = NR SUBSEP col
	if ($col == "S") {
	    grid[loc] = ord["a"]
	    queue[++n_queue] = loc
	    len[loc] = 0
	}
	else if ($col == "E") {
	    end = loc
	    grid[loc] = ord["z"]
	} else {
	    grid[loc] = ord[$col]
	}
    }
}
END {
    rows = NR
    for (col = 1 ; col <= cols ; col++){ # pad the top and bottom
	len[0,col] = -1
	len[rows+1,col] = -1
    }
    print shortest_path()
}

# queue holds the visited locations
#   before calling it should contain all starting locations
# len holds the path lengths (if a loc is in len, it has been visited)
#   before starting it should contain all the starting locations and
#   sides of the grid
function shortest_path(    loc, rowcol, row, col, newloc) {
    while(top < n_queue) {
	loc = queue[++top]
	if (loc == end)
	    return len[loc]

	split(loc, rowcol, SUBSEP)
	row = rowcol[1]
	col = rowcol[2]

	for (i = 0 ; i < 4 ; i++) {
	    newloc = row + drow[i] SUBSEP col + dcol[i]
	    if (!(newloc in len) && can_reach(grid[newloc], grid[loc])){
		len[newloc] = len[loc] + 1
		queue[++n_queue] = newloc
	    }
	}
    } print "NO PATH"
}

function can_reach(to, from) { return to <=  from + 1 }
