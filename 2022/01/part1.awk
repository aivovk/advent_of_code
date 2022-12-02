/[0-9]+/ {sum += $1}
/^$/ {if (sum > max) max = sum ; sum = 0}
END {print max}
