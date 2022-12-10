BEGIN { RS = "" ; nmax = 3 }
{
    for (i = 1 ; i <= NR ; i++) sum += $i
    for (i = 1 ; i <= nmax && sum > max[i] ; i++) {
	max[i-1] = max[i]
	max[i] = sum
    }
    sum = 0
}
END {
    for (i = 1 ; i <= nmax ; i++) sum_nmax += max[i]
    print max[nmax] "\n" sum_nmax
}
