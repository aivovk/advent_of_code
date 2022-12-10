{ sum += $1 }
/^$/ { update() }
END { update() ; print max }

function update() { if (sum > max) max = sum ; sum = 0 }
