BEGIN { RS = "" }
{
    for (i = 1 ; i <= NR ; i++) sum += $i
    if (sum > max) max = sum
    sum = 0
}
END { print max }
