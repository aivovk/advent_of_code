BEGIN {
  dx["L"] = -1
  dx["R"] = 1
  dy["U"] = 1
  dy["D"] = -1
  # need to init or null string instead of 0 keys in visited
  xrope[1] = yrope[1] = xrope[9] = yrope[9] = 0
}
{
    while($2-- > 0) {
	xrope[0] += dx[$1]
	yrope[0] += dy[$1]
	for (i = 1 ; i <= 9 ; i++) {
	    xdiff = xrope[i-1] - xrope[i]
	    ydiff = yrope[i-1] - yrope[i]
	    if (max(abs(xdiff), abs(ydiff)) == 2) {
		xrope[i] += sign(xdiff)
		yrope[i] += sign(ydiff)
	    } else break
	}
	visited1[xrope[1],yrope[1]]=1
	visited9[xrope[9],yrope[9]]=1
    }
}
END { print length(visited1)"\n"length(visited9) }

function abs(a) { return a < 0 ? -a : a }
function max(a, b) { return a < b ? b : a }
# if statement and dividing by abs gives different answer?
function sign(a) { return a < 0 ? -1 : (a > 0 ? 1 : 0)}
