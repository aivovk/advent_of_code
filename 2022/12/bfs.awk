END { # search must be called in END section of importing script
    for(;i<256;i++) height[sprintf("%c",i)]=i
    height["S"] = height["a"] ; height["E"] = height["z"]
    drow[1] = -1 ; drow[2] = 1
    dcol[3] = -1 ; dcol[4] = 1
    n_dirs = 4
    FS = SUBSEP # assuming importing scripts won't use FS at END
}

# GLOBAL grid[rows,cols]: the heightmap markers
# locs: the locations visited at depth
# visited: visited locations, can be the same array as locs at depth=0 (only in gawk)
# depth:
function search(locs, visited,    depth,    newlocs, loc, newloc) {
    for (loc in locs) {
	if (grid[loc] == "E")
	    return depth
	$0 = loc # $1 = row, $2 = col
	for (i = 1 ; i <= n_dirs ; i++) {
	    newloc = $1 + drow[i] SUBSEP $2 + dcol[i]
	    if (newloc in grid && !(newloc in visited) && can_reach(grid[newloc], grid[loc])){
		newlocs[newloc]
		visited[newloc]
	    }
	}
    }
    if (depth > 0) delete locs # how to check if locs and visited are the same reference?
    return search(newlocs, visited, depth+1)
}

function can_reach(to, from) { return height[to] <=  height[from] + 1 }
