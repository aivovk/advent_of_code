BEGIN {
    FS = SUBSEP = ","
    dx[1] = dy[2] = dz[3] = -1
    dx[4] = dy[5] = dz[6] = 1
    n_dirs = 6
}
{
    cubes[$0]
    x = $1 ; y = $2 ; z = $3
    minx = min(x,minx) ; maxx = max(x,maxx)
    miny = min(y,miny) ; maxy = max(y,maxy)
    minz = min(z,minz) ; maxz = max(z,maxz)
    surface_area += 6 - 2 * count_neighbours($0, cubes)
}
NR == 1 { minx = maxx = x ; miny = maxy = y ; minz = maxz = z }
END {
    # part 1
    print surface_area
    # part 2
    minx-- ; miny-- ; minz-- ; maxx++ ; maxy++ ; maxz++
    for (x = minx ; x <= maxx ; x++)
	for (y = miny ; y <= maxy ; y++)
	    for (z = minz ; z <= maxz ; z++)
		if (!(x SUBSEP y SUBSEP z in cubes))
		    space[x,y,z]
    queue[minx,miny,minz]
    remove_outer_space(space, queue)
    for (xyz in space)
	inner_surface_area += 6 - count_neighbours(xyz, space)
    print surface_area - inner_surface_area
}

function min(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }

function count_neighbours(xyz, arr,    n) {
    $0 = xyz ; x = $1 ; y = $2 ; z = $3
    for (i = 1 ; i <= n_dirs ; i++)
	if (x+dx[i] SUBSEP y+dy[i] SUBSEP z+dz[i] in arr)
	    n++
    return n
}

function remove_outer_space(space, queue,    next_queue){ #another bfs
    if (length(queue) == 0) return
    for (xyz in queue) {
	delete space[xyz]
	$0 = xyz ; x = $1 ; y = $2 ; z = $3
	for (i = 1 ; i <= n_dirs ; i++)
	    if (x+dx[i] SUBSEP y+dy[i] SUBSEP z+dz[i] in space)
		next_queue[x+dx[i], y+dy[i], z+dz[i]]
    }
    delete queue
    remove_outer_space(space, next_queue)
}
  
