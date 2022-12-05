BEGIN { data = "crates" }
NR == 1 { n_stacks =  (length($0) + 1) / 4 }
data == "crates" && $1 == 1 { # match the line with stack numbers
  data = "moves"
  FS = "[a-z ]+"
  getline
  for (i = 1 ; i <= n_stacks ; i++)
      crates2[i] = crates1[i]
}
data == "crates" {
    for ( i = 1 ; i <= n_stacks ; i++){
	c = substr($0, i * 4 - 2, 1)
	if (c != " ")
	    crates1[i] = crates1[i] c
    }
}
data == "moves" { n = $2 ; from = $3 ; to = $4
    crates1[to] = reverse(substr(crates1[from], 1, n)) crates1[to]
    crates1[from] = substr(crates1[from], n + 1)
    crates2[to] = substr(crates2[from], 1, n) crates2[to]
    crates2[from] = substr(crates2[from], n + 1)
}
END {
    for (i = 1 ; i <= n_stacks ; i++) printf(substr(crates1[i], 1, 1))
    printf("\n")
    for (i = 1 ; i <= n_stacks ; i++) printf(substr(crates2[i], 1, 1))
    printf("\n")
}

function reverse(s,    i, r) {
    for ( i = 1 ; i <= length(s) ; i++)
	r = substr(s, i, 1) r
    return r
}
