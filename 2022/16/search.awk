function max(a, b) { return a > b ? a : b }

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
