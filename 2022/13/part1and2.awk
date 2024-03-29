BEGIN { RS = "" ; FS="\n" ; packet2="[[2]]" ; packet6="[[6]]" }
{
    if (compare($1, $2) < 0) sum += NR
    if (compare($1, packet2) < 0) p2++
    if (compare($2, packet2) < 0) p2++
    if (compare($1, packet6) < 0) p6++
    if (compare($2, packet6) < 0) p6++
}
END { print sum "\n" (p2+1) * (p6+2) }

function compare(l, r) {
    if (match(l r, /^[0-9]+$/)) return l - r
    gsub(/^\[|\]$/, "", l) ; gsub(/^\[|\]$/, "", r) ; return compare_list(l, r)
}

function compare_list(left, right,    n, l, r, res) {
    # l is first element, left is the remaining list
    n = get_next(left) ; l = substr(left, 1, n-1) ; left = substr(left, n+1)
    n = get_next(right) ; r = substr(right, 1, n-1) ; right = substr(right, n+1)
    while (l != "" || r != "") {
	if (l == "") return -1
	if (r == "") return 1
	res = compare(l, r)
	if (res != 0) return res
	n = get_next(left) ; l = substr(left, 1, n-1) ; left = substr(left, n+1)
	n = get_next(right) ; r = substr(right, 1, n-1) ; right = substr(right, n+1)
    }
    return 0
}

function get_next(s,    stack, i) { #index of next "," that splits the list
    for (i = 1 ; i <= length(s) ; i++){
	if (stack == 0 && substr(s, i, 1) == ",") break
        if (substr(s,i,1) == "[") stack++
        else if (substr(s,i,1) == "]") stack--
    }
    return i
}
