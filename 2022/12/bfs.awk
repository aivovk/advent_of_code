BEGIN {
    for(;i<256;i++) height[sprintf("%c",i)]=i
    height["S"] = height["a"] ; height["E"] = height["z"]
    drow[1] = -1 ; drow[2] = 1
    dcol[3] = -1 ; dcol[4] = 1
    n_dirs = 4
}
END { FS = SUBSEP } # assuming importing scripts won't use FS at END

# GLOBAL grid[rows,cols]: the heightmap markers
# GLOBAL visited: visited locations (contains starting locations before first call)
# locs: the locations visited at the last depth
function search(locs, depth,    newlocs, loc, newloc) {
    for (loc in locs) {
	if (grid[loc] == "E")
	    return depth
	$0 = loc # $1 = row, $2 = col
	for (i = 1 ; i <= n_dirs ; i++) {
	    newloc = $1 + drow[i] SUBSEP $2 + dcol[i]
	    if (grid[newloc] && !(newloc in visited) && can_reach(grid[newloc], grid[loc])){
		newlocs[newloc]
		visited[newloc]
	    }
	}
    }
    return search(newlocs, depth+1)
}

function can_reach(to, from) { return height[to] <=  height[from] + 1 }
