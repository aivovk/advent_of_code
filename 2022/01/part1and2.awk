BEGIN { nmax = 3 }
{ sum += $1 }
/^$/ { update() }
END { update()
    for (i = 1 ; i <= nmax ; i++) sum_nmax += max[i]
    print max[nmax]
    print sum_nmax
}

function update() {
    for (i = 1 ; i <= nmax && sum > max[i] ; i++) {
	max[i-1] = max[i]
	max[i] = sum
    }
    sum = 0
}
