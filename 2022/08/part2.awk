BEGIN { FS = "" }
NR == 1 { n = NF }
{
    row = NR
    for (col = 1 ; col <= n ; col ++)
	trees[row-1,col-1] = $col
}
END {
    for (row = 1 ; row < n - 1  ; row ++) {
	for (col = 1 ; col < n - 1  ; col ++) {
	    tree = trees[row,col]
	    up = 1 ; down = 1 ; left = 1 ; right = 1
	    while(row-up>0 && trees[row-up,col] < tree) { up++ }
	    while(row+down<n-1 && trees[row+down,col] < tree) { down++ }
	    while(col-left>0 && trees[row,col-left] < tree) { left++ }
	    while(col+right<n-1 &&trees[row,col+right] < tree) { right++ }
	    view = up * down * left * right
	    if (view > max) max = view
	}
    }
    print max
}

