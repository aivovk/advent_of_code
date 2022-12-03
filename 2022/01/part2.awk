{sum += $1}
/^$/ {if (sum > max1) {
	if (sum > max2) {
	    max1 = max2
	    if (sum > max3) { max2 = max3 ; max3 = sum }
	    else max2 = sum
	}
	else max1 = sum
    }
    sum = 0}
END {print max1+max2+max3}
