# 7 seconds
{
    init[NR-1] = NR - 1 # the positions of the initial index
    arr[NR-1] = $0      # the sequence
}
END {
    for (i = 0 ; i < NR ; i++)
	for (j = 0 ; j < NR ; j++)
	    if (init[j] == i){ # j is the current position of the number to mix
		# figure out the new position
		dist = arr[j]
		# there are NR-1 locations a number can go
		# (between any two other numbers)
		# an example: it takes NR-1 swaps to get to the
		# same order: 1,2,3 -> 1,3,2 -> 2,3,1 (mixing 2)
		if (dist < 0)
		    dist = -((-dist) % (NR-1))
		# make sure it is positive
		new_j = (NR-1 + j + dist) % (NR-1)
		
		# swap the sequence, and the initial indexes
		dj = new_j > j ? 1 : -1
		while (j != new_j){
		    swap(init, j, j+dj)
		    swap(arr, j, j+dj)
		    j += dj
		}
		break
	    }
    for (i = 0 ; i < NR ; i++)
	if (arr[i] == 0)
	    print arr[(i+1000)%NR] + arr[(i+2000)%NR] + arr[(i+3000)%NR]
}

function swap(a, i, j) { temp = a[i] ; a[i] = a[j] ; a[j] = temp }
