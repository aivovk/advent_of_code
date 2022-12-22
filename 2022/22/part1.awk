BEGIN {
    FS = ""
    dcol[0] = 1
    drow[1] = 1
    dcol[2] = -1
    drow[3] = -1
    n_dirs = 4
    data = "map"
}
NF == 0 { maxrow = NR - 1 ; data = "path" ; next }
data == "map" {
    for (col = 1 ; col <= NF ; col++){
	if (!startcol && $col != " ") startcol = col - 1
	if ($col != " ") map[NR-1, col-1] = $col
    }
    if (NF > maxcol) maxcol = NF
    next
}
data == "path" {
    row = 0 ; col = startcol ; facing = 0
    do{
	nextrow = row
	nextcol = col
	match($0, /^([0-9]+)([RL])?/, arr)
	steps = arr[1]
	while (steps > 0){
	    nextrow = (maxrow + nextrow + drow[facing]) % maxrow
	    nextcol = (maxcol + nextcol + dcol[facing]) % maxcol
	    if (map[nextrow,nextcol] == "#") break
	    if (map[nextrow,nextcol] == "."){
		steps--
		row = nextrow ; col = nextcol
	    }
	}
	if (2 in arr)
	    facing = (n_dirs + facing + (arr[2] == "R" ? 1 : -1 )) % n_dirs
    } while (sub(/^[0-9]+[RL]/, ""))
    print 1000 * (row+1) + 4 * (col+1) + facing
}
