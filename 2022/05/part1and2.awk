NR == 1 { n_stacks =  (length($0) + 1) / 4 }
$1 == 1 { # match the line with stack numbers
    getline ; getline
    for (i = 1 ; i <= n_stacks ; i++) crates2[i] = crates1[i] # copy for part 2
}
$1 != "move" {
    for (i = 1 ; i <= n_stacks ; i++){
	crate = substr($0, i * 4 - 2, 1)
	if (crate != " ") crates1[i] = crates1[i] crate
    }
}
$1 == "move" { n = $2 ; from = $4 ; to = $6
    crates1[to] = reverse(substr(crates1[from], 1, n)) crates1[to]
    crates1[from] = substr(crates1[from], n + 1)
    crates2[to] = substr(crates2[from], 1, n) crates2[to]
    crates2[from] = substr(crates2[from], n + 1)
}
END {
    for (i = 1 ; i <= n_stacks ; i++) printf(substr(crates1[i], 1, 1))
    print ""
    for (i = 1 ; i <= n_stacks ; i++) printf(substr(crates2[i], 1, 1))
    print ""
}
function reverse(s,    i, r) {
    for (i = 1 ; i <= length(s) ; i++) r = substr(s, i, 1) r
    return r
}
