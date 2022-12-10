BEGIN { X = 1 ; cycle = 1 }
$1 == "noop" { tick() ; next }
$1 == "addx" { tick() ; tick() ; X += $2 ; next }
END { tick() ; print signal_strength }

function tick() {
    if (cycle % 20 == 0 && cycle % 40 != 0 && cycle <= 220)
	signal_strength += cycle * X
    cycle++
}
