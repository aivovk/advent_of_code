BEGIN{ FS="-|," }
($1 - $3) * ($2 - $4) <= 0 { p1++ }
$3 <= $2 && $1 <= $4 { p2++ }
END { print p1"\n"p2 }
