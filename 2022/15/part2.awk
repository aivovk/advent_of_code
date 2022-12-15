# very slow
BEGIN {
    FS = "[^0-9-]+"
    TO = ":"
    SEP = ","
    minxy = 0
    maxxy = 4000000 # maxxy=20 for test
    for (y = minxy ; y <= maxxy ; y++)
	ranges[y]
}
{
    sx = $2
    sy = $3
    bx = $4
    by = $5
    d = abs(sx-bx) + abs(sy-by)
    for (y = max(sy - d, minxy) ; y <= min(sy + d, maxxy) ; y ++){
	if (y in ranges) {
	    dx = d - abs(y - sy)
	    ranges[y] = update_range(ranges[y], max(sx - dx, minxy), min(sx + dx, maxxy))
	    if (start(ranges[y]) <= minxy && end(ranges[y]) >= maxxy)
		delete ranges[y]
	}
    }
}
END {
    for (y in ranges)
	print y + 4000000 * (end(ranges[y]) + 1)
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
