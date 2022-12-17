# Part 2 shouldn't count as solved:
# - record the index in the jet pattern and the x position that the ####
#   occured at (and the height and rock number)
# - when there is a duplicate (same x position of #### at a previously
#   seen pattern index), increment the height and the rock number by the
#   difference from the previous occurence, until this would complete
#   more than 10^12 steps
# - run the remainder of the simulation
# if height is recorded, output is +1 of test answer
# if y is recorded instead of height, output is -1 of test answer
# answer on input is correct in both cases

# Edit: skip recording the above for the first 2022 rocks (so that
# the test answer for Part 1 is printed), now the test answer for
# Part 2 is also correct. This probably "forgets" the initial condition
# of #######. Still not really a solution.

# Edit 2: tried checking for filled levels (#######), but they don't seem to
# occur

BEGIN {
    # read the "rocks" file before the puzzle input
    ARGC = 3
    ARGV[2] = ARGV[1]
    ARGV[1] = "rocks"
    pass = 1
    RS = "" # split on blank lines
}
NR > FNR { pass = 2 } # read the puzzle input
pass == 1 { # read and store rocks numbered 0,1,2,3,4
    # bottom goes in row 0
    for (row = NF-1 ; row >= 0 ; row--)
	rocks[NR-1,row] = $(NF-row)
    n_rows[NR-1] = NF
}
pass == 2 { jet_pattern = $0 }
END {
    part1 = 2022
    steps = 1000000000000
    n_rocks = NR - FNR
    height = 0
    blank_level = "......."
    tower[height] = "#######"
    n_jet = 0
    for (n_rock = 0 ; n_rock < steps - pseudo_steps ; n_rock++){
	# PART 1:
	if (n_rock == part1) print height

	i_rock = n_rock % n_rocks
	width = length(rocks[i_rock,0])

	# bottom left corner of rock
	x = 2 ; y = height + 4 # 3 units above means 3 unit gap, so 4 above
	while (1) {
	    i_jet = n_jet++ % length(jet_pattern)
	    if (substr(jet_pattern, 1 + i_jet, 1) == ">"){
		if (!is_overlap(x+1, y))
		    x++
	    } else
		if (!is_overlap(x-1, y))
		    x--
	    if (!is_overlap(x, y-1))
		y--
	    else{
		# add rock to tower
		for (row = 0 ; row < n_rows[i_rock] ; row++) {
		    if (y + row > height)
			level = substr(blank_level, 1, x)
		    else
			level = substr(tower[y+row], 1, x)
		    for (col = 0 ; col < width ; col++) {
			c = "."
			if (substr(rocks[i_rock, row], col + 1, 1) == "#" || \
			    substr(tower[y+row], x + col + 1, 1) == "#")
			    c = "#"
			level = level c
		    }
		    if (y + row > height)
			level = level substr(blank_level, x+width+1)
		    else
			level = level substr(tower[y+row], x+width+1)
		    tower[y+row] = level
		}
		height = max(height, y+n_rows[i_rock]-1)

		# PART 2:
		if (n_rock > max(part1, length(jet_pattern)) &&	\
		    pseudo_height == 0 && i_rock == 0) {
		    if (i_jet SUBSEP x in prev_height){
			diff_height = height - prev_height[i_jet,x]
			diff_rock = n_rock - prev_step[i_jet,x]
			remainder = (steps - n_rock) % diff_rock
			repeats = (steps - n_rock - remainder) / diff_rock
			pseudo_steps += diff_rock * repeats
			pseudo_height += diff_height * repeats
		    } else {
			prev_height[i_jet,x] = height
			prev_step[i_jet,x] = n_rock
		    }
		}
		break
	    }
	}
    }
    print height + pseudo_height
}

function max(a, b) { return a > b ? a : b }

# check if the rock overlaps the tower if bottom left is at x, y
# GLOBALS
#   tower: state of the tower
#   height: tallest level of the tower
#   rocks: state for each rock
#   n_rows: heights of each rock
#   i_rock: index of current rock being dropped
#   width: (of the current rock)
function is_overlap(x, y,    row, col) {
    for (row = 0 ; row < n_rows[i_rock] ; row++){
	if (x < 0 || x + width > 7) # hit the walls
	    return 1
	if (y+row > height) # above tower
	    return 0
	for (col = 0 ; col < width ; col++)
	    if (substr(tower[y + row], x + col + 1, 1) == "#" && \
		substr(rocks[i_rock, row], col + 1, 1) == "#")
		return 1
    }
    return 0
}
