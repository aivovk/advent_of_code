BEGIN { FS = "" }
NR == 1 { n = NF }
{
    row = NR
    for (col = 1 ; col <= n ; col ++)
	trees[row-1,col-1] = $col
}
END {
    for (i = 1 ; i < n - 1 ; i ++) {
	row_max = trees[i,0]
	col_max = trees[0,i]
	rev_row_max = trees[i,n-1]
	rev_col_max = trees[n-1,i]
	for (j = 1 ; j < n - 1 ; j ++) {
	    if (trees[i,j] > row_max){
		visible[i,j] = 1
		row_max = trees[i,j]
	    }
	    if (trees[j,i] > col_max){
		visible[j,i] = 1
		col_max = trees[j,i]
	    }
	    if (trees[i,n-1-j] > rev_row_max){
		visible[i,n-1-j] = 1
		rev_row_max = trees[i,n-1-j]
	    }
	    if (trees[n-1-j,i] > rev_col_max){
		visible[n-1-j,i] = 1
		rev_col_max = trees[n-1-j,i]
	    }
	}
    }
    print 4 * (n - 1) + length(visible)
}

