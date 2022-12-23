BEGIN { FS = "" }
{ for (i = 1 ; i <= NF ; i++) if($i == "#") elves[NR, i] }
END {
    FS = SUBSEP
    for (turn = 0 ; turn < 10 ; turn++){
	delete moves ; delete n_moving_to
	for (elf in elves) {
	    move = propose_move(elf)
	    # move_from contains the elf locs (values) moving to a new loc (key)
	    if (move)
		move_from[move,++n_moving_to[move]] = elf
	}
	for (move in n_moving_to){
	    if (n_moving_to[move] == 1) {
		delete elves[move_from[move,1]]
		elves[move]
	    }
	}
    }
    for (elf in elves) { # not initializing min/max!
	$0 = elf ; row = $1 ; col = $2
	if (row < minrow) minrow = row
	if (row > maxrow) maxrow = row
	if (col < mincol) mincol = col
	if (col > maxcol) maxcol = col
    }
    print (1 + maxrow - minrow) * (1 + maxcol - mincol) - length(elves)
}

function propose_move(pos) {
    $0 = pos ; row = $1 ; col = $2
    if (!(row-1 SUBSEP col-1 in elves) &&				\
	!(row-1 SUBSEP col in elves) &&					\
	!(row-1 SUBSEP col+1 in elves) &&				\
	!(row+1 SUBSEP col-1 in elves) &&				\
	!(row+1 SUBSEP col in elves) &&					\
	!(row+1 SUBSEP col+1 in elves) &&				\
	!(row SUBSEP col-1 in elves) &&					\
	!(row SUBSEP col+1 in elves))
	return
    
    for (dir = turn ; dir < turn + 4 ; dir++) {
	if (dir % 4 == 0){ # NORTH
            if (!(row-1 SUBSEP col-1 in elves) &&	\
		!(row-1 SUBSEP col in elves) &&		\
		!(row-1 SUBSEP col+1 in elves))
                return row-1 SUBSEP col
	} else if (dir % 4 == 1){ # SOUTH
	    if (!(row+1 SUBSEP col-1 in elves) &&	\
		!(row+1 SUBSEP col in elves) &&		\
		!(row+1 SUBSEP col+1 in elves))
                return row+1 SUBSEP col
	} else if (dir % 4 == 2) { # WEST
	    if (!(row-1 SUBSEP col-1 in elves) &&			\
		!(row SUBSEP col-1 in elves) &&				\
		!(row+1 SUBSEP col-1 in elves))
                return row SUBSEP col-1
	} else { # dir % 4 == 3, EAST
	    if (!(row-1 SUBSEP col+1 in elves) &&	\
		!(row SUBSEP col+1 in elves) &&		\
		!(row+1 SUBSEP col+1 in elves))
		return row SUBSEP col+1
	}
    }
    return
}
