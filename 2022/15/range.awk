# set FS
BEGIN {
    TO = ":"
    SEP = ","
}
function abs(a) { return a < 0 ? -a : a }
function min(a, b) { return a < b ? a : b }
function max(a, b) { return a > b ? a : b }

function start(range) {
    $0 = range
    return $1
}
# returns the end of the first range
function end(range) {
    $0 = range
    return $2
}

function is_last(range) {
    return index(range, SEP) == 0
}

function strip_first(range) {
    return substr(range, index(range, SEP) + 1)
}

function update_range(range, new_start, new_end) {
    if (!range) return new_start TO new_end
    old_start = start(range) ; old_end = end(range)

    # no overlap and precedes
    if (new_end < old_start - 1)
	return new_start TO new_end SEP range
    # overlap only with first range and precedes
    if (new_end <= old_end)
	if (is_last(range))
	    return min(new_start, old_start) TO old_end
	else
	    return min(new_start, old_start) TO old_end SEP strip_first(range)
    # overlap with first range
    if (new_start <= old_end + 1)
	if (is_last(range))
	    return min(new_start, old_start) TO max(new_end, old_end)
        else
	    return update_range(strip_first(range), min(new_start, old_start), max(new_end, old_end))
    # no overlap, after first range
    if (is_last(range))
	return old_start TO old_end SEP new_start TO new_end
    else
	return old_start TO old_end SEP update_range(strip_first(range), new_start, new_end)
}

function sum(ranges) { # assume ranges is not empty
    first_start = start(ranges)
    first_end = end(ranges)
    sum_first = first_end - first_start + 1
    if (is_last(range)){
	return sum_first
    }
    return sum_first + sum(strip_first(ranges))
}
