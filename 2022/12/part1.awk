@include "shortest_path.awk"
BEGIN { FS = "" }
NR == 1 { cols = NF }
{
    len[NR,0] = len[NR,cols+1] = -1 # pad the sides
    for (col = 1 ; col <= cols ; col++){
	loc = NR SUBSEP col
	if ($col == "S") {
	    queue[++n_queue] = loc
	    len[loc] = 0
	}
	grid[loc] = $col
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
