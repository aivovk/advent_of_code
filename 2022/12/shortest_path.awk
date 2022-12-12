BEGIN {
    for(;i<256;i++) height[sprintf("%c",i)]=i
    height["S"] = height["a"] ; height["E"] = height["z"]
    drow[1] = -1 ; drow[2] = 1
    dcol[3] = -1 ; dcol[4] = 1
    n_dirs = 4
}

# grid[rows,cols]: the heightmap markers
# queue[n_queue]: the visited locations
#   before calling it should contain all starting locations
# len: the path lengths (if a loc is in len, it has been visited)
#   before starting it should contain all the starting locations and
#   edges of the grid
function shortest_path(    top, loc, rowcol, row, col, newloc) {
    while(top < n_queue) {
	loc = queue[++top]
	delete queue[top-1]
	if (grid[loc] == "E")
	    return len[loc]

	split(loc, rowcol, SUBSEP)
	row = rowcol[1]
	col = rowcol[2]

	for (i = 1 ; i <= n_dirs ; i++) {
	    newloc = row + drow[i] SUBSEP col + dcol[i]
	    if (!(newloc in len) && can_reach(grid[newloc], grid[loc])){
		len[newloc] = len[loc] + 1
		queue[++n_queue] = newloc
	    }
	}
    } return "NO PATH"
}

function can_reach(to, from) { return height[to] <=  height[from] + 1 }
