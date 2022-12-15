# 1) transform coordinates (the diamonds covered by beacons become squares)
# 2) find any squares that have a 1 width or 1 height gap between them
#   (and the start/end of this gap)
# 3) intersect the horizontal and vertical gaps
# Note: this doesn't cover the case where the beacon is in the corner or at the
# side of the defined area and cannot be found between 4 sensors (not my input)
BEGIN {
    FS = "[^0-9-]+"
    SEP = ","
}
{
    sx = $2 ; sy = $3 ; bx = $4 ; by = $5
    d = abs(sx-bx) + abs(sy-by)
    # transform coordinates
    cx = sx + sy
    cy = sx - sy
    new_square = d SEP cx SEP cy

    for (square in squares) {
	h = horizontal_overlap(square, new_square)
	v = vertical_overlap(square, new_square)
	if (h) h_overlaps[h]
	if (v) v_overlaps[v]
    }
    squares[new_square]
}
END {
    for (h in h_overlaps)
	for (v in v_overlaps)
	    if (b = intersect(h, v))
		beacons[b]
    for (b in beacons){
	$0 = b
	# transform back
	x = ($1 + $2) / 2
	y = ($1 - $2) / 2
	print y + 4000000 * x
    }
}

function abs(a) { return a < 0 ? -a : a }
function min(a, b) { return a < b ? a : b }
function max(a, b) { return a > b ? a : b }

function intersect(h, v) {
    # h_overlap : xleft SEP xright SEP y
    # v_overlap : x SEP ybottom SEP ytop
    $0 = h ; xleft = $1 ; xright = $2 ; y = $3
    $0 = v ; x = $1 ; ybottom = $2 ; ytop = $3
    if (x < xleft || x > xright || y < ybottom || y > ytop) return
    return x SEP y
}

function horizontal_overlap(square1, square2) {
    # square : d SEP cx SEP cy
    $0 = square1 ; d1 = $1 ; x1 = $2 ; y1 = $3
    $0 = square2 ; d2 = $1 ; x2 = $2 ; y2 = $3
    if (d1 + d2 + 2 != abs(y2 - y1)) return
    if (y2 > y1) y = y1 + d1 + 1
    else y = y1 - d1 - 1
    xleft = max(x1-d1, x2-d2)
    xright = min(x1+d1,x2+d2)
    if (xleft <= xright) return xleft SEP xright SEP y
    return
}

function vertical_overlap(square1, square2) {
    return htov(horizontal_overlap(swapsq(square1), swapsq(square2)))
}

function swapsq(square){ # swap coordinates in a square
    $0 = square
    return $1 SEP $3 SEP $2
}

function htov(h){ # swap coordinates in a horizontal overlap
    if (!h) return
    $0 = h
    return $3 SEP $1 SEP $2
}
