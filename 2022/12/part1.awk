@include "bfs.awk"
BEGIN { FS = "" }
NR == 1 { cols = NF }
{
    for (col = 1 ; col <= cols ; col++){
	loc = NR SUBSEP col
	if ($col == "S")
	    visited[loc]
	grid[loc] = $col
    }
}
END {
    rows = NR
    print search(visited, visited)
}
