BEGIN { FS="" } { print find_distinct(4)"\n"find_distinct(14) }

function find_distinct(n,    cc, i){ # cc: char counter
    for (i = 1 ; i <= NF ; i++){
	cc[$i]++
	if (i > n) if (--cc[$(i-n)] == 0) delete cc[$(i-n)]
	if (length(cc) == n) return i
    }
}
