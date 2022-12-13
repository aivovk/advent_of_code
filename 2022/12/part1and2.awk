@include "bfs.awk"
BEGIN { FS = "" }
NR == 1 { cols = NF }
{
    for (col = 1 ; col <= cols ; col++){
	loc = NR SUBSEP col
	if ($col == "S") { start1[loc] ; start2[loc] }
	if ($col == "a") { start2[loc] }
	grid[loc] = $col
    }
}
END {
    rows = NR
    print search(start1, start1)"\n"search(start2, start2) # same array ref only safe in gawk
}
