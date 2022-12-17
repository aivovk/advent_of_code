@include "search.awk"
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

    print search("AA", 30, 0, closed)
}
