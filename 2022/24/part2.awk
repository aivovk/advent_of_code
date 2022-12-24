BEGIN {
    FS = ""
    n_dirs = 5 ; dcol[0] = 1 ; drow[1] = 1 ; dcol[2] = -1 ; drow[3] = -1
}
NR == 1 {
    cols = NF - 2
    for (i = 2 ; i < NF ; i++) if ($i == ".") { start_col = i - 2 ; next }
}
{
    for (i = 2 ; i < NF ; i++) {
	pos = NR - 2 SUBSEP i - 2
	if ($i == ">")
	    right_blizzards[pos]
	else if ($i == "v")
	    down_blizzards[pos]
	else if ($i == "<")
	    left_blizzards[pos]
	else if ($i == "^")
	    up_blizzards[pos]
    }
}
END {
    FS = SUBSEP
    rows = NR - 2
    for (i = 2 ; i < NF ; i ++) if ($i == ".") { end_col = i - 2 ; break }
    queue[-1, start_col]
    # move blizzards
    for (blizzard in right_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_right_blizzards[row,(col+1) % cols]
    }
    for (blizzard in down_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_down_blizzards[(row+1)%rows,col]
    }
    for (blizzard in left_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_left_blizzards[row,(cols+col-1) % cols]
    }
    for (blizzard in up_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_up_blizzards[(rows+row-1)%rows,col]
    }
    print search(queue, 0, next_right_blizzards, next_down_blizzards, next_left_blizzards, next_up_blizzards)
}

function search(queue, time, right_blizzards, down_blizzards, left_blizzards, up_blizzards,    next_queue, next_right_blizzards, next_down_blizzards, next_left_blizzards, next_up_blizzards, only_add_next) {
    # move to all locations
    for (pos in queue) {
	$0 = pos ; row = $1 ; col = $2
	if (phase == 0){
	    if (row == rows && col == end_col){
		delete next_queue
		only_add_next = 1
		phase++
	    }
	}
	else if (phase == 1) {
	    if (row == -1 && col == start_col){
		delete next_queue
		only_add_next=1
		phase++
	    }
	} else if (phase == 2) {
	    if (row == rows && col == end_col)
		return time
	}

	for (dir = 0 ; dir < n_dirs ; dir++){
	    new_row = row + drow[dir]
	    new_col = col + dcol[dir]
	    if (can_move(new_row, new_col, right_blizzards, down_blizzards, left_blizzards, up_blizzards)){
		next_queue[new_row SUBSEP new_col]
	    }
	}
	if (only_add_next) break
    }
    # move blizzards
    for (blizzard in right_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_right_blizzards[row,(col+1) % cols]
    }
    for (blizzard in down_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_down_blizzards[(row+1)%rows,col]
    }
    for (blizzard in left_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_left_blizzards[row,(cols+col-1) % cols]
    }
    for (blizzard in up_blizzards){
	$0 = blizzard ; row = $1 ; col = $2
	next_up_blizzards[(rows+row-1)%rows,col]
    }
    return search(next_queue, time+1, next_right_blizzards, next_down_blizzards, next_left_blizzards, next_up_blizzards)
}

function can_move(row,col,right_blizzards, down_blizzards, left_blizzards, up_blizzards,    pos){
    pos = row SUBSEP col
    return !(pos in right_blizzards) &&				\
	!(pos in down_blizzards) &&				\
	!(pos in left_blizzards) &&				\
	!(pos in up_blizzards) &&				\
	(col >= 0) && (col < cols) &&				\
	(row < rows || (row == rows && col == end_col)) &&	\
	(row >= 0 || (row == -1 && col == start_col))
}
