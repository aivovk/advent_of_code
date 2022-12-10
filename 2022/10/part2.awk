BEGIN { X = 1 } # note: cycle starts at 0, not 1
$1 == "noop" { tick() ; next }
$1 == "addx" { tick() ; tick() ; X += $2 ; next }

function tick() {
    if (cycle % 40 <= X + 1 && cycle % 40 >= X - 1) printf("#")
    else printf(".")
    cycle++
    if (cycle % 40 == 0) printf("\n")
}
