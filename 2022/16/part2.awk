# takes ~3mins on input
BEGIN { FS="[ ,=:;a-z]+" }
{
    valve=$2
    rates[valve] = $3
    tunnels[valve,++n_tunnels[valve]] = $4
    for (i = 5 ; i <= NF ; i++) tunnels[valve,++n_tunnels[valve]] = $i
    if ($3 != 0) closed[valve]
}
END {
    # get the shortest path between two valves
    bfs_fill("AA") # consider the starting valve
    for (valve in closed) bfs_fill(valve) # and any non-zero rate valve
    
    # cut the search time in half, one valve is never opened
    # by the elephant
    for (valve in closed){
	delete closed[valve]
	closed1[valve]
	break
    }
    split("", closed2) # declare empty arrays
    partition_and_search(closed, closed1, closed2)
    print maxval
}

function max(a, b) { return a > b ? a : b }

# partition the closed valves into two sets
# and search them using the part 1 solution
# GLOBALS:
#   maxval : max pressure released by any partition
function partition_and_search(closed, closed1, closed2,    released, valve) {
    if (length(closed) == 0){
	released = search("AA", 26, 0, closed1) + search("AA", 26, 0, closed2)
	if (released > maxval) maxval = released
    } else {
	# get 1 valve from closed and add it to each set
	for (valve in closed) {
	    delete closed[valve]
	    closed1[valve]
	    partition_and_search(closed, closed1, closed2)
	    delete closed1[valve]
	    closed2[valve]
	    partition_and_search(closed, closed1, closed2)
	    delete closed2[valve]
	    closed[valve]
	    break # only pop 1 valve
	}
    }
}

function bfs_fill(start,  top, queue, visited, n_queue) {
    visited[start]
    queue[++n_queue] = start
    top++
    d = 1
    while (top <= n_queue){
	n = n_queue
	for ( ; top <= n ; top++) {
	    v = queue[top]
	    for (i = 1 ; i <= n_tunnels[v] ; i++) {
		valve2 = tunnels[v,i]
		if (!(valve2 in visited)){
		    visited[valve2]
		    path_length[start, valve2] = d
		    queue[++n_queue] = valve2
		}
	    }
	}
	d++
    }
    delete visited
}

# starting at `valve` (with remaining `time`, and pressure `released`)
# maximize the pressure released by opening the `closed` valves
# GLOBALS :
#   path_length : shortest path between any two valves
#   rates : flow rate of each valve
function search(valve, time, released, closed,    tunnel, d, maxval) {
    if (time < 0) return -1
    if (time <= 2) return released
    maxval = released
    for (tunnel in closed){
	if (valve!= tunnel) {
	    delete closed[tunnel]
	    d = path_length[valve, tunnel]
	    maxval = max(maxval, search(tunnel, time-d-1, released + (time-d-1) * rates[tunnel], closed))
	    closed[tunnel]
	}
    }
    return maxval
}
